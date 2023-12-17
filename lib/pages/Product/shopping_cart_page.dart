import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ShoppingCartPage extends ConsumerStatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends ConsumerState<ShoppingCartPage> {
  
  @override
  Widget build(BuildContext context) {

    final watchCant = ref.watch(chCant);
    final watchMoney = ref.watch(chMoney);

    return Scaffold(
      appBar: showAppBar('Carrito de la compra'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            customGroupBox('Información del carrito', [
              dosisBold('Cantidad de productos: ', watchCant.toString(), 20),
              dosisBold('Monto de la compra: ', watchMoney.toStringAsFixed(2), 20)
            ]),

            const Flexible(child: ShowList())

          ],
        )
      ),
    );

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


class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {

  @override
  Widget build(BuildContext context) {

    final watchProductList = ref.watch(chProductList);
    final watchCant = ref.read(chCant.notifier);

    return Scaffold(
      body: ListView.builder(
        itemCount: watchProductList.length,
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

                (watchProductList[index].photo.isEmpty)
                  ? Image.asset('lib/assets/images/no_image.jpg')
                  : productPhoto(watchProductList[index].photo),

                productInfo(
                  watchProductList[index].name, 
                  watchProductList[index].price.toString(),
                  watchProductList[index].commission.toString()
                ),

                const Spacer(),

                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(100)
                    ),
                    child: dosisText('5', size: 15, 
                      color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                )

              ],
            ),
          );

        }
      
      )

    );

  }

  Container productInfo(String name, String price, String commision) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dosisText(name, fontWeight: FontWeight.bold),
          dosisText('Precio: \$$price', color: Colors.blue),
          dosisText('Comisión: $commision%', color: Colors.red),
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

    final watchProductList = ref.watch(chProductList);
    final watchCant = ref.watch(chCant);
    final watchMoney = ref.watch(chMoney);

    return Container(
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 1
        )]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: (){}, 
            icon: const Icon(Icons.add, color: Colors.grey,
            size: 20,)),

          Container(
            height: 30,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue[100],  
              borderRadius: BorderRadius.circular(100)
            ),
            child: dosisText('5', size: 15, color: Colors.blue, fontWeight: FontWeight.bold),
          ),

          IconButton(onPressed: (){}, 
            icon: const Icon(Icons.remove, color: Colors.grey,
            size: 20,)),
        ],
      ),
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
