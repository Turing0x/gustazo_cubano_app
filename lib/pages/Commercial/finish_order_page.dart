import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/helpers/determinate_amount.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:intl/intl.dart';

class FinishOrderPage extends ConsumerStatefulWidget {
  const FinishOrderPage({super.key, required this.coin, required this.mlc, required this.usd});

  final String coin;
  final double mlc;
  final double usd;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FinishOrderPageState();
}

class _FinishOrderPageState extends ConsumerState<FinishOrderPage> {
  String referralCode = '';
  String ci = '';
  String fullName = '';
  String phone = '';
  String address = '';

  @override
  void initState() {
    LoginDataService().getCommercialCode().then((value) {
      setState(() {
        referralCode = value!;
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
            onPressed: () {
              List list = [];
              rProdList.products.forEach((key, value) {
                list.add(value);
              });

              Map<String, dynamic> order = {
                'date': DateTime.now().toString(),
                'product_list': list,
                'total_amount': rProdList.totalAmount,
                'type_coin': widget.coin,
                'commission': rProdList.totalCommissionMoney(ref).toStringAsFixed(2),
                'seller': {
                  'commercial_code': referralCode,
                  'ci': ci,
                  'full_name': fullName,
                  'phone': phone,
                  'address': address,
                }
              };

              Navigator.pushNamed(context, 'buyer_info_page', arguments: [order]);
            },
            icon: const Icon(Icons.send))
      ]),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            topInfo(rProdList),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: MediaQuery.of(context).size.height * 0.65,
                child: ListCartView(
                  rProdList: rProdList,
                  coinType: widget.coin,
                  mlc: widget.mlc,
                  usd: widget.usd,
                ))
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.black)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          dosisText(DateFormat.yMEd().add_jms().format(DateTime.now())),
          dosisText(fullName, size: 20, fontWeight: FontWeight.bold),
          dosisText(
              (widget.coin == 'CUP')
                  ? 'Pago en Moneda Nacional ( CUP )'
                  : (widget.coin == 'MLC')
                      ? 'Transferencia de Moneda Libremente Convertible ( MLC )'
                      : (widget.coin == 'USD')
                          ? 'Pago en efectivo de Dólar Estadounidense ( USD )'
                          : 'Transferencia Bancaria Directa USD ( ZELLE )',
              fontWeight: FontWeight.bold),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dosisBold('Total de productos: ', rProdList.productsCant.toString(), 20),
              dosisBold(
                  'Monto: \$',
                  '${(rProdList.whatCoin() == widget.coin) ? rProdList.totalAmount : calculatePurchaseAmount(ref, widget.coin, rProdList.totalAmount)}',
                  20)
            ],
          )
        ],
      ),
    );
  }
}

class ListCartView extends ConsumerStatefulWidget {
  const ListCartView({
    super.key,
    required this.rProdList,
    required this.coinType,
    required this.mlc,
    required this.usd,
  });

  final ShoppingCartProvider rProdList;
  final String coinType;
  final double mlc;
  final double usd;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListCartViewState();
}

class _ListCartViewState extends ConsumerState<ListCartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: widget.rProdList.products.length,
        itemBuilder: (context, index) {
          Product product = widget.rProdList.products.values.elementAt(index);

          return ListTile(
            title: dosisText(product.name, fontWeight: FontWeight.bold),
            subtitle: dosisBold(
                'Precio: \$',
                '${(product.coin == widget.coinType) ? product.price : calculatePurchaseAmount(ref, widget.coinType, product.price)}',
                18),
            trailing: dosisText(product.cantToBuy.toString(), fontWeight: FontWeight.bold),
          );
        },
      ),
    );
  }
}
