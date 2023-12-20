import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/config/utils/local_storage.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:intl/intl.dart';

class FinishOrderPage extends StatefulWidget {
  const FinishOrderPage({super.key});

  @override
  State<FinishOrderPage> createState() => _FinishOrderPageState();
}

class _FinishOrderPageState extends State<FinishOrderPage> {

  String fullname = '';
  String referalCode = '';

  @override
  void initState() {
    LocalStorage.getFullName().then((value) {
      setState(() {
        fullname = value!;
      });
    });
    LocalStorage.getReferalCode().then((value) {
      setState(() {
        referalCode = value!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final rProdList = ShoppingCartProvider();

    return Scaffold(
      appBar: showAppBar('Revisar pedido', actions: [
        IconButton(
          onPressed: (){

            final orderCrtl = OrderControllers();

            List list = [];
            rProdList.products.forEach((key, value) {
              list.add({
                'name': value.name,
                'price': value.price,
                'cantToBuy': value.cantToBuy,
                'commision': value.commission,
              });
            });

            Map<String, dynamic> order = {
              'date': DateTime.now().toString(),
              'product_list': list,
              'total_amount': rProdList.totalAmount,
              'commision': rProdList.totalCommisionMoney.toStringAsFixed(2),
              'seller': {
                'fullName': fullname,
                'referalCode': referalCode,
              }
            };

            orderCrtl.saveOrder(order);

          }, 
          icon: const Icon(Icons.send)
        )
      ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
        
            topInfo(rProdList),
        
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: MediaQuery.of(context).size.height * 0.65,
              child: ListCartView(rProdList: rProdList))
        
          ],
        ),
      ),
    );
  }

  Container topInfo(ShoppingCartProvider rProdList) {
    return Container(
      height: 130,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          dosisText(DateFormat.yMEd().add_jms().format(DateTime.now())),

          dosisText(fullname, size: 20, fontWeight: FontWeight.bold),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dosisBold('Total de artículos: ', rProdList.productsCant.toString(), 20),
              dosisBold('Monto: \$', rProdList.totalAmount.toStringAsFixed(2), 20)
            ],
          )
        ],
      ),
    );
  }

}

class ListCartView extends StatelessWidget {
  const ListCartView({
    super.key,
    required this.rProdList,
  });

  final ShoppingCartProvider rProdList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: rProdList.products.length,
        itemBuilder: (context, index) {
          
          Product product = rProdList.products.values.elementAt(index);

          return ListTile(
            title: dosisText(product.name, fontWeight: FontWeight.bold),
            subtitle: dosisBold('Precio: \$', product.price.toString(), 18),
            trailing: dosisText(product.cantToBuy.toString(), fontWeight: FontWeight.bold),
          );
      
        },
      ),
    );
  }
}