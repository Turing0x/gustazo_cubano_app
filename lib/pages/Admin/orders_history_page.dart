// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/Pdf/commission/admin_pdf_commission.dart';
import 'package:gustazo_cubano_app/config/Pdf/commission/admin_pdf_daily.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/Select_date/select_date.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

List<Order> listToPdf = [];

class OrdersHistoryPage extends ConsumerStatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends ConsumerState<OrdersHistoryPage> {
  bool show = false;

  @override
  void initState() {
    LoginDataService().getRole().then((value) {
      if (value == 'admin') {
        setState(() {
          show = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Historial de órdenes', actions: [menu()]),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [CustomDateSelect(), Expanded(child: ShowList())],
        ),
      ),
    );
  }

  void makePDF() async {
    DateTime date = listToPdf[0].date;
    String fecha = '${date.day}/${date.month}/${date.year}';
    Map<String, dynamic> itsDone = await GenerateAdminPdfCommission.generate(listToPdf, fecha);

    if (itsDone['done'] == true) {
      OpenFile.open(itsDone['path']);
    } else {
      simpleMessageSnackBar(context, texto: itsDone['path'], typeMessage: true);
      return;
    }

    simpleMessageSnackBar(context, texto: 'Factura exportada exitosamente', typeMessage: true);
  }

  void makeDailyPDF() async {
    DateTime date = listToPdf[0].date;
    String fecha = DateFormat.MMMd('en').format(date);

    List<Product> list = await ProductControllers().getDataForDaily(fecha);
    if (list.isEmpty) return;

    Map<String, dynamic> itsDone = await GenerateAdminPdfDaily.generate([], fecha);

    if (itsDone['done'] == true) {
      OpenFile.open(itsDone['path']);
    } else {
      simpleMessageSnackBar(context, texto: itsDone['path'], typeMessage: true);
      return;
    }

    simpleMessageSnackBar(context, texto: 'Factura exportada exitosamente', typeMessage: true);
  }

  PopupMenuButton menu() {
    return PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        onSelected: (value) async {
          Map<String, void Function()> methods = {
            'commi': () => makePDF(),
            'daily': () => makeDailyPDF(),
          };
          methods[value]!.call();
        },
        itemBuilder: (BuildContext context) => [
              PopupMenuItem(value: 'commi', child: dosisText('Cálculo de comisiones', size: 18)),
              PopupMenuItem(
                value: 'daily',
                child: dosisText('Resúmen del día', size: 18),
              )
            ]);
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
    final janddate = ref.watch(janddateR);

    return Scaffold(
      body: FutureBuilder(
        future: OrderControllers().getAllOrders(true, date: janddate.currentDate),
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
                      dosisText('Comprador: ${order.buyer.fullName}', fontWeight: FontWeight.bold),
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
