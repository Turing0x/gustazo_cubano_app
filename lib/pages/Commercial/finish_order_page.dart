import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:intl/intl.dart';

class FinishOrderPage extends StatefulWidget {
  const FinishOrderPage({super.key, required this.coin, required this.mlc, required this.usd});

  final String coin; 
  final double mlc; 
  final double usd; 

  @override
  State<FinishOrderPage> createState() => _FinishOrderPageState();
}

class _FinishOrderPageState extends State<FinishOrderPage> {

  String referalCode = '';
  String ci = '';
  String fullName = '';
  String phone = '';
  String address = '';

  @override
  void initState() {
    LoginDataService().getCommercialCode().then((value) {
      setState(() {
        referalCode = value!;
      });
    });
    LoginDataService().getCi().then((value) {
      setState(() {
        ci = value!;
      });
    });
    LoginDataService().getFullName().then((value) {
      setState(() {
        fullName = value!;
      });
    });
    LoginDataService().getPhone().then((value) {
      setState(() {
        phone = value!;
      });
    });
    LoginDataService().getAddress().then((value) {
      setState(() {
        address = value!;
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
              'type_coin': widget.coin,
              'commission': rProdList.totalCommisionMoney.toStringAsFixed(2),
              'seller': {
                'commercial_code': referalCode,
                'ci': ci,
                'full_name': fullName,
                'phone': phone,
                'address': address,
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
              child: ListCartView(rProdList: rProdList, 
                coinType: widget.coin, 
                mlc: widget.mlc, 
                usd: widget.usd,))
        
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

          dosisText(fullName, size: 20, fontWeight: FontWeight.bold),
          dosisText(( widget.coin == 'CUP' )
            ? 'Pago en Moneda Nacional ( CUP )'
            : (widget.coin == 'MLC')
              ? 'Transferencia de Moneda Libremente Convertible ( MLC )'
              : (widget.coin == 'USD')
                ? 'Pago en efectivo de Dólar Estadounidense ( USD )'
                : 'Transferencia Bancaria Directa USD ( ZELLE )', fontWeight: FontWeight.bold),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dosisBold('Total de productos: ', rProdList.productsCant.toString(), 20),
              dosisBold('Monto: \$', (widget.coin == 'CUP')
                ? '${rProdList.totalAmount.toStringAsFixed(2)} ${widget.coin}'
                : ( widget.coin == 'MLC' )
                  ? '${(rProdList.totalAmount / widget.mlc).toStringAsFixed(2)} ${widget.coin}'
                  : '${(rProdList.totalAmount / widget.usd).toStringAsFixed(2)} ${widget.coin}', 20)
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
    required this.rProdList, required this.coinType, required this.mlc, required this.usd,
  });

  final ShoppingCartProvider rProdList;
  final String coinType;
  final double mlc;
  final double usd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: rProdList.products.length,
        itemBuilder: (context, index) {
          
          Product product = rProdList.products.values.elementAt(index);

          return ListTile(
            title: dosisText(product.name, fontWeight: FontWeight.bold),
            subtitle: dosisBold('Precio: \$', (coinType == 'CUP')
              ? product.price .toStringAsFixed(2)
              : ( coinType == 'MLC' )
                ? (product.price / mlc).toStringAsFixed(2)
                : (product.price / usd).toStringAsFixed(2), 18),
            trailing: dosisText(product.cantToBuy.toString(), fontWeight: FontWeight.bold),
          );
      
        },
      ),
    );
  }
}