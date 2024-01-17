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
            mainAxisSize: MainAxisSize.min,
            children: [

              topRow(invoice.title, image),
              
              pw.SizedBox(height: 100),

              pw.Align(
                alignment: Alignment.centerLeft,
                child: pwtextoDosis('Datos', 35, fontWeight: pw.FontWeight.bold),
              ),
              
              pw.SizedBox(height: 50),
              
              infoRow(invoice),

              pw.SizedBox(height: 100),
              // buildInvoice(invoice),

              pw.SizedBox(height: 100),

            ]
          )
        )
      ],
    );
  }

  static Row topRow( String title, MemoryImage image  ){
    return pw.Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        pw.Image(image),
        pwtextoDosis(title, 28, fontWeight: pw.FontWeight.bold),
      ]
    );
  }
  
  static Row infoRow( CommisionInvoce invoice ){
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
            pwboldLabel( 'Ventas logradas: ', '${invoice.userName} - ${invoice.userName}', 23),
            pwboldLabel( 'Fecha: ', invoice.userName, 23)
          ]
        )
      ]
    );
  }

  // static Widget buildInvoice(CommisionInvoce invoice) {
  //   final headers = [
  //     'Producto',
  //     'Cantidad',
  //     'Precio',
  //   ];

  //   final data = invoice.productList.map((item) {

  //     return [
  //       Container(child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           pwtextoDosis(item.name, 23),
  //           pwboldLabel('Vendido por: ', "E' Gustazo Cubano S.U.R.L", 20)
  //         ]
  //       )),
  //       Container(child: pwtextoDosis(item.cantToBuy.toString(), 23)),
  //       Container(child: pwtextoDosis('CUP ${item.price.toString()}', 23)),
  //     ];
  //   }).toList();

  //   data.add([
  //     Container(
  //       child: pwtextoDosis('Totales', 23, 
  //         fontWeight: FontWeight.bold)), 
  //     Container(
  //       child: pwtextoDosis(invoice.productList.fold(0, (previousValue, element) => 
  //         previousValue + element.cantToBuy).toString(), 23, 
  //         fontWeight: FontWeight.bold)),
  //     Container(
  //       child: pwtextoDosis(invoice.productList.fold(0.0, (previousValue, element) => 
  //         previousValue + element.price).toStringAsFixed(2), 23,
  //         fontWeight: FontWeight.bold)),
  //     ]);

  //   return TableHelper.fromTextArray(
  //     headers: headers,
  //     data: data,
  //     headerStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: PdfColors.white),
  //     headerDecoration: const BoxDecoration(color: PdfColors.black),
  //     cellHeight: 30,
  //     cellAlignments: {
  //       0: Alignment.centerLeft,
  //       1: Alignment.centerLeft,
  //       2: Alignment.centerLeft,
  //     },
  //     cellDecoration: (column, dataRow, row) {
  //       if (row == data.length) {
  //         return const BoxDecoration(color: PdfColors.grey300);
  //       } else {
  //         return const BoxDecoration(color: PdfColors.white);
  //       }
  //     },
  //   );
  // }

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
