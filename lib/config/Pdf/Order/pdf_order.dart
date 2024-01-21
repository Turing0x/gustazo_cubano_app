import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gustazo_cubano_app/config/Pdf/invoces/order_invoce.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/bold_text.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/texto_dosis.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class GeneratePdfOrder {
  static Future<Map<String, dynamic>> generate(OrderInvoce invoice) async {

    try {

      final pdf = Document();

      final image = pw.MemoryImage(
        (await rootBundle.load('lib/assets/images/pdf_logo.png')).buffer.asUint8List(),
      );

      pdf.addPage(multiPage(invoice, image));

      final fileName = 'ORDEN-${invoice.orderNumber.replaceAll(' ', '')}-${invoice.orderDate.split(' - ')[0].replaceAll('/', '-')}';

      Directory? appDocDirectory = await getExternalStorageDirectory();
      Directory directory =
        await Directory('${appDocDirectory?.path}/PDFDocs')
          .create(recursive: true);

      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());
      return {'done': true, 'path': file.path};

    } catch (onError) {
      return {'done': false, 'path': onError.toString()};
    }

  }

  static pw.MultiPage multiPage(OrderInvoce invoice, MemoryImage image) {
    return MultiPage(
      pageFormat: const PdfPageFormat(1500, 1500),
      build: (context) => [
        pw.Container(
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
          child: pw.Column(
            children: [

              topRow(invoice.title, invoice.address, image),
              
              pw.SizedBox(height: 100),

              pw.Align(
                alignment: Alignment.centerLeft,
                child: pwtextoDosis('FACTURA', 35, fontWeight: pw.FontWeight.bold),
              ),
              
              pw.SizedBox(height: 50),
              
              infoRow(invoice),

              pw.SizedBox(height: 100),
              buildInvoice(invoice),

              pw.SizedBox(height: 100),

              pw.Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  signatures('Facturado'),
                  signatures('Despachado'),
                  signatures('Recibido')
                ]
              ),

            ]
          )
        )
      ],
    );
  }

  static Row topRow( String title, String address, MemoryImage image  ){
    return pw.Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        pw.Image(image),
        pw.Column(
          children: [
            pwtextoDosis(title, 28, fontWeight: pw.FontWeight.bold),
            pwtextoDosis(address, 25),
          ]
        )
      ]
    );
  }
  
  static Row infoRow( OrderInvoce invoice ){
    return pw.Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pwtextoDosis('Información de comprador', 25, fontWeight: pw.FontWeight.bold),
            pwboldLabel('Nombre Completo: ', invoice.buyerName, 23),
            pwboldLabel('Carnet de Identidad: ', invoice.buyerCi, 23),
            pwboldLabel('Dirección: ', invoice.buyerAddress, 23),
            pwboldLabel('Teléfono de Contacto: ', invoice.buyerPhone, 23),
            pwboldLabel('Forma de Gestión Económica: ', invoice.buyerEconomic, 23),
          ]
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pwtextoDosis('Información de pedido', 25, fontWeight: pw.FontWeight.bold),
            pwboldLabel( 'Número: ', '${invoice.pendingNumber} - ${invoice.orderNumber}', 23),
            pwboldLabel( 'Fecha: ', invoice.orderDate, 23)
          ]
        )
      ]
    );
  }

  static Widget buildInvoice(OrderInvoce invoice) {
    final headers = [
      'Producto',
      'Cantidad',
      'Precio',
      'Importe',
    ];

    final data = invoice.productList.map((item) {

      return [
        Container(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pwtextoDosis(item.name, 23),
            pwboldLabel('Vendido por: ', item.provider, 20)
          ]
        )),
        Container(child: pwtextoDosis(item.cantToBuy.toString(), 23)),
        Container(child: pwtextoDosis('${item.price.numFormat} CUP', 23)),
        Container(child: pwtextoDosis('${(item.cantToBuy * item.price).numFormat} CUP', 23)),
      ];
    }).toList();

    data.add([
      Container(
        child: pwtextoDosis('Totales', 23, 
          fontWeight: FontWeight.bold)), 
      Container(
        child: pwtextoDosis(invoice.productList.fold(0, (previousValue, element) => 
          previousValue + element.cantToBuy).toString(), 23, 
          fontWeight: FontWeight.bold)),
      Container(
        child: pwtextoDosis('${invoice.productList.fold(0.0, (previousValue, element) => 
          previousValue + element.price).numFormat} CUP', 23,
          fontWeight: FontWeight.bold)),
      Container(
        child: pwtextoDosis('${invoice.productList.fold(0.0, (previousValue, element) => 
          previousValue + element.cantToBuy * element.price).numFormat} CUP', 23,
          fontWeight: FontWeight.bold)),
      ]);

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PdfColors.white),
      headerDecoration: const BoxDecoration(color: PdfColors.black),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerLeft,
      },
      cellDecoration: (column, dataRow, row) {
        if (row == data.length) {
          return const BoxDecoration(color: PdfColors.grey300);
        } else {
          return const BoxDecoration(color: PdfColors.white);
        }
      },
    );
  }

  static Column signatures(String text){
    return pw.Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        pwtextoDosis('$text por: ', 23, fontWeight: pw.FontWeight.bold),
        pwtextoDosis('Nombre y Apellido', 23),
        pwtextoDosis('C.I', 23),
        pwtextoDosis('Firma', 23),
      ]
    );
  }

}
