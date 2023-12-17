import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/models/shopping_cart.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class MainCommercialPage extends ConsumerStatefulWidget {
  const MainCommercialPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainCommercialPageState();
}

class _MainCommercialPageState extends ConsumerState<MainCommercialPage> {

  @override
  Widget build(BuildContext context) {

    final watchCant = ref.watch(chCant);
    final watchMoney = ref.watch(chMoney);

    final watchProductList = ref.watch(chProductList);

    return Scaffold(
      appBar: showAppBar('Productos en stock', centerTitle: false, actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.transparent,
          )),
          onPressed: () {
            if(watchProductList.isEmpty) {
              simpleMessageSnackBar(context,
                texto: 'EL carrito de la compra esta vacío', typeMessage: false);
              return;
            }

            Navigator.pushNamed(context, 'shopping_cart_page');
          },
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white,), 
          label: dosisText('Carrito', color: Colors.white,)
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){}, 
        label: dosisText(
          '$watchCant Productos - Total: \$${watchMoney.toStringAsFixed(2)}',
          fontWeight: FontWeight.bold)),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const ShowList()
      ),
    );
  }
}

class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {

  @override
  Widget build(BuildContext context) {

    ProductControllers productCtrl = ProductControllers();
    final prod = ShoppingCart();

    return Scaffold(
      body: FutureBuilder(
        future: productCtrl.getAllProducts(),
        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context, 
              'Parece que no tenemos productos en stock en este momento');
          }
      
          final products = snapshot.data;
      
          return ListView.builder(
            itemCount: products!.length,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 1
                  )]
                ),
                child: Row(
                  children: [

                    (products[index].photo.isEmpty)
                      ? Image.asset('lib/assets/images/no_image.jpg')
                      : productPhoto(products[index].photo),

                    productInfo(products[index].name, products[index].price.toString()),

                    const Spacer(),

                    dosisText(prod.getCantOfProduct(products[index].id)),
                    const SizedBox(width: 5),

                    addBuyBtn(products[index])

                  ],
                ),
              );

            })
            ;
          },

        ),

    );

  }

  Container productInfo(String name, String price) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dosisText(name, fontWeight: FontWeight.bold),
          dosisText('\$$price', color: Colors.blue)
        ],
      )
    );
  }

  ClipRRect productPhoto(String photo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.fromSize(
        size: const Size.fromRadius(48),
        child: Image.network(photo, fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },errorBuilder: (context, error, stackTrace) {
            return Image.asset('lib/assets/images/no_image.jpg');
          },
        ),
      ),
    );
  }

  SizedBox addBuyBtn(Product product) {

    return SizedBox(
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                final prod = ShoppingCart();
                prod.addToCar(product.id);
                prod.showCar();
              },
              child: Container(
                width: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                ),
                child: dosisText('+', size: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final prod = ShoppingCart();
                prod.lessToCar(product.id);
                prod.showCar();
              },
              child: Container(
                width: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  )
                ),
                child: dosisText('-', size: 22, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      )
    );
  }

  bool isInCar(Product product) {
    final watchProductList = ref.watch(chProductList);
    return watchProductList.any((element) => element.id == product.id);
  }

  void manager(bool type, double price){

    final watchCant = ref.read(chCant.notifier);
    final watchMoney = ref.read(chMoney.notifier);

    if(type){
      watchCant.state += 1;
      watchMoney.state += price;
    }else{
      watchCant.state -= 1;
      watchMoney.state -= price;
    }
  }

}
