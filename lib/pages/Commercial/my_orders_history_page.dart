// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/Pdf/commission/pdf_commission.dart';
import 'package:gustazo_cubano_app/config/Pdf/invoices/commission_invoice.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/shared/Select_date/select_date.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:open_file/open_file.dart';

List<Order> listToPdf = [];

class MyOrdersHistoryPage extends StatefulWidget {
  const MyOrdersHistoryPage({super.key, required this.commercialCode});

  final String commercialCode;

  @override
  State<MyOrdersHistoryPage> createState() => _MyOrdersHistoryPageState();
}

class _MyOrdersHistoryPageState extends State<MyOrdersHistoryPage> {
  String ci = '';
  String fullName = '';
  String phone = '';
  String address = '';

  @override
  void initState() {
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
    return Scaffold(
      appBar: showAppBar('Historial de órdenes',
          actions: [IconButton(onPressed: () => makePDF(), icon: const Icon(Icons.picture_as_pdf_outlined))]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            const CustomDateSelect(),
            Expanded(
                child: ShowList(
              commercialCode: widget.commercialCode,
            ))
          ],
        ),
      ),
    );
  }

  void makePDF() async {
    final invoice = CommissionInvoice(
      userCi: ci,
      userName: fullName,
      userPhone: phone,
      userAddress: address,
      orderList: listToPdf,
    );

    Map<String, dynamic> itsDone = await GeneratePdfCommission.generate(invoice);

    if (itsDone['done'] == true) {
      OpenFile.open(itsDone['path']);
    } else {
      simpleMessageSnackBar(context, texto: itsDone['path'], typeMessage: true);
      return;
    }

    simpleMessageSnackBar(context, texto: 'Factura exportada exitosamente', typeMessage: true);
  }
}

class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key, required this.commercialCode});

  final String commercialCode;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {
  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(janddateR);

    return Scaffold(
      body: FutureBuilder(
        future: OrderControllers().getMyOrders(widget.commercialCode, janddate.currentDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context, 'No tenemos pedidos en este momento. Vuelva en otro momento');
          }

          final list = snapshot.data;
          listToPdf = list!;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              Order order = list[index];

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)]),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      dosisText('Comprador: ${order.buyer.fullName.split(' ')}', fontWeight: FontWeight.bold),
                      dosisText('Comercial: ${order.seller.fullName.split(' ')[0]}'),
                    ],
                  ),
                  subtitle: dosisBold('Factura: ', order.invoiceNumber, 18),
                  trailing: const Icon(Icons.arrow_right_rounded),
                  onTap: () => Navigator.pushNamed(context, 'order_details_page', arguments: [order]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
