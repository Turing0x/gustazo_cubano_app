import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/bold_text.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/texto_dosis.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class GenerateAdminPdfDaily {
  static Future<Map<String, dynamic>> generate(List<Order> invoice, String date) async {
    try {
      final pdf = Document();

      final image = pw.MemoryImage(
        (await rootBundle.load('lib/assets/images/pdf_logo.png')).buffer.asUint8List(),
      );

      pdf.addPage(multiPage(invoice, image, date));

      final fileName = 'Diario-$date';

      Directory? appDocDirectory = await getExternalStorageDirectory();
      Directory directory = await Directory('${appDocDirectory?.path}/PDFDocs').create(recursive: true);

      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(await pdf.save());

      return {'done': true, 'path': file.path};
    } catch (onError) {
      return {'done': false, 'path': onError.toString()};
    }
  }

  static pw.MultiPage multiPage(List<Order> invoice, MemoryImage image, String date) {
    return MultiPage(
      pageFormat: const PdfPageFormat(1500, 1500),
      build: (context) => [
        pw.Container(
            margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
            child: pw.Column(children: [
              topRow(image),
              pw.SizedBox(height: 100),
              pw.Align(
                alignment: Alignment.centerLeft,
                child: pwtextoDosis('Resumen De Ventas del Día', 35, fontWeight: pw.FontWeight.bold),
              ),
              pw.Align(
                alignment: Alignment.centerLeft,
                child: pwboldLabel('Para la fecha: ', date, 28),
              ),
              pw.SizedBox(height: 100),
              buildInvoice(invoice),
              pw.SizedBox(height: 100),
            ]))
      ],
    );
  }

  static Row topRow(MemoryImage image) {
    return pw.Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      pw.Image(image),
      pw.Column(children: [
        pwtextoDosis('E Gustazo Cubano', 28, fontWeight: pw.FontWeight.bold),
        pwtextoDosis('Calle 222 e/ 29 y 31 La Coronela. La Lisa', 25),
      ])
    ]);
  }

  static Widget buildInvoice(List<Order> invoice) {
    final headers = [
      'Código',
      'Nombre',
      'Total de Productos',
      'Monto Total',
      'Ganancia',
      'Rebaja del 5%',
    ];

    final data = invoice.map((item) {
      return [
        Container(child: pwtextoDosis(item.seller.commercialCode, 23)),
        Container(child: pwtextoDosis(item.seller.fullName, 23)),
        Container(child: pwtextoDosis(item.getCantOfProducts.toString(), 23)),
        Container(child: pwtextoDosis('${item.totalAmount.numFormat} CUP', 23)),
        Container(child: pwtextoDosis('${item.commission.numFormat} CUP', 23)),
        Container(child: pwtextoDosis('${(item.commission - item.commission * 0.05).numFormat} CUP', 23)),
      ];
    }).toList();

    int foldedProducts = invoice.fold(0, (previousValue, element) => previousValue + element.getCantOfProducts);
    double foldedAmount = invoice.fold(0.0, (previousValue, element) => previousValue + element.totalAmount);
    double foldedCommission = invoice.fold(0.0, (previousValue, element) => previousValue + element.commission);

    data.add([
      Container(child: pwtextoDosis('Totales', 23, fontWeight: FontWeight.bold)),
      Container(child: pwtextoDosis('', 23, fontWeight: FontWeight.bold)),
      Container(child: pwtextoDosis(foldedProducts.toString(), 23, fontWeight: FontWeight.bold)),
      Container(child: pwtextoDosis('$foldedAmount CUP', 23, fontWeight: FontWeight.bold)),
      Container(child: pwtextoDosis('$foldedCommission CUP', 23, fontWeight: FontWeight.bold)),
      Container(
          child: pwtextoDosis('${(foldedCommission - foldedCommission * 0.05).numFormat} CUP', 23,
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
        3: Alignment.centerLeft,
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
}
