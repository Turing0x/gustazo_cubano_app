import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class AddProductsOnEditing extends StatefulWidget {
  const AddProductsOnEditing({super.key});

  @override
  State<AddProductsOnEditing> createState() => _AddProductsOnEditingState();
}

class _AddProductsOnEditingState extends State<AddProductsOnEditing> {

  List<Product> products = [];

  @override
  void initState() {

    ProductControllers().getAllProducts().then((value) {
      if(value.isNotEmpty){
        for (var element in value) {
          setState(() {
            products.add(element);
          });
        }
      }
    });

    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Añadir productos', centerTitle: false, actions: [
        OutlinedButton.icon(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.done, color: Colors.white),
          label: dosisText('Listo', color: Colors.white),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.transparent)
          ),
        )
      ]),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: (products.isEmpty)
          ? noData(context, 
              'Parece que no tenemos productos en stock en este momento')
          : ShowList(products: products)
      ),
    );
  }
}


class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key,
    required this.products  
  });

  final List<Product> products;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: widget.products.length,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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

                Image.asset('lib/assets/images/no_image.jpg'),

                productInfo(widget.products[index].name, widget.products[index].price.toString()),

                const Spacer(),

                addBuyBtn(widget.products[index])

              ],

            ),

          );

        }

      )

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

  Container addBuyBtn(Product product) {

    final productList = StateNotifierProvider<ShoppingCartProvider, Product>(
      (ref) => ShoppingCartProvider());
    final rProdList = ref.read(productList.notifier);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 1
        )]
      ),
      child: IconButton(
        onPressed: (){
          if(!rProdList.isInCart(product.id)){
            setState(() {
              rProdList.addProductToList(product);
            });
          }else {
            setState(() {
              rProdList.removeProductFromList(product.id);
            });
          }
        }, 
        icon: (rProdList.isInCart(product.id))
          ? const Icon(Icons.remove_shopping_cart_outlined, color: Colors.red)
          : const Icon(Icons.add_shopping_cart_outlined, color: Colors.blue)
      )
    );
  }

}
