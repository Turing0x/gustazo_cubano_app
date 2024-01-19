import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gustazo_cubano_app/config/Pdf/invoces/commision_invoce.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/bold_text.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/texto_dosis.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class GeneratePdfCommision {
  static Future<Map<String, dynamic>> generate(CommisionInvoce invoice) async {

    try {

      final pdf = Document();

      final image = pw.MemoryImage(
        (await rootBundle.load('lib/assets/images/pdf_logo.png')).buffer.asUint8List(),
      );

      pdf.addPage(multiPage(invoice, image));

      final fileName = 'COMISION-${invoice.title.split(' ')[1]}';

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

  static pw.MultiPage multiPage(CommisionInvoce invoice, MemoryImage image) {
    return MultiPage(
      pageFormat: const PdfPageFormat(1500, 1500),
      build: (context) => [
        pw.Container(
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
          child: pw.Column(
            children: [

              topRow(invoice.title, image, invoice.address),
              
              pw.SizedBox(height: 100),

              pw.SizedBox(height: 50),
              
              infoRow(invoice),

              pw.SizedBox(height: 100),
              buildInvoice(invoice),

              pw.SizedBox(height: 100),

            ]
          )
        )
      ],
    );
  }

  static Row topRow( String title, MemoryImage image, String address ){
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
  
  static Row infoRow( CommisionInvoce invoice ){

    double foldedCommision = invoice.orderList.fold(0, 
      (previousValue, element) => previousValue + element.commission);

    return pw.Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pwtextoDosis('Información de comprador', 25, fontWeight: pw.FontWeight.bold),
            pwboldLabel('Nombre Completo: ', invoice.userName, 23),
            pwboldLabel('Carnet de Identidad: ', invoice.userCi, 23),
            pwboldLabel('Dirección: ', invoice.userAddress, 23),
            pwboldLabel('Teléfono de Contacto: ', invoice.userPhone, 23),
          ]
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pwtextoDosis('Información de venta', 25, fontWeight: pw.FontWeight.bold),
            pwboldLabel( 'Ventas logradas: ', '${invoice.orderList.length}', 23),
            pwboldLabel( 'Ganancia Total: ', 'CUP ${foldedCommision.toStringAsFixed(2)}', 23)
          ]
        )
      ]
    );
  }

  static Widget buildInvoice(CommisionInvoce invoice) {
    final headers = [
      'Número de Órden',
      'Fecha',
      'Cantidad de Productos',
      'Monto de la Venta',
    ];

    final data = invoice.orderList.map((item) {

      return [
        Container(child: pwtextoDosis('${item.pendingNumber} - ${item.invoiceNumber}', 23)),
        Container(child: pwtextoDosis(item.date.toString(), 23)),
        Container(child: pwtextoDosis('${item.getCantOfProducts}', 23)),
        Container(child: pwtextoDosis('CUP ${item.totalAmount.toStringAsFixed(2)}', 23)),
      ];
    }).toList();

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
        3: Alignment.centerLeft,
      },
    );
  }

}
