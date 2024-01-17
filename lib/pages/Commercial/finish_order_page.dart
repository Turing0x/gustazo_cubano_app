import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
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
    LoginDataService().getFullName().then((value) {
      setState(() {
        fullname = value!;
      });
    });
    LoginDataService().getCommercialCode().then((value) {
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
            
            List list = [];
            rProdList.products.forEach((key, value) {
              list.add(value);
            });


            Map<String, dynamic> order = {
              'date': DateTime.now().toString(),
              'product_list': list,
              'total_amount': rProdList.totalAmount,
              'commission': rProdList.totalCommisionMoney.toStringAsFixed(2),
              'seller': {
                'fullName': fullname,
                'referalCode': referalCode,
              }
            };

            Navigator.pushNamed(context, 'buyer_info_page', arguments: [
              order
            ]);

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
              dosisBold('Total de productos: ', rProdList.productsCant.toString(), 20),
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