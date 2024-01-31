import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gustazo_cubano_app/config/Pdf/invoices/order_invoice.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/bold_text.dart';
import 'package:gustazo_cubano_app/config/Pdf/widgets/texto_dosis.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class GeneratePdfOrder {
  static Future<Map<String, dynamic>> generate(OrderInvoice invoice) async {

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

  static pw.MultiPage multiPage(OrderInvoice invoice, MemoryImage image) {
    return MultiPage(
      pageFormat: const PdfPageFormat(1500, 1500),
      build: (context) => [
        pw.Container(
          margin: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
          child: pw.Column(
            children: [

              topRow(invoice.title, invoice.address, image,
                '${invoice.pendingNumber} - ${invoice.orderNumber}', 
                  invoice.orderDate, invoice.paymentMethod),

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

  static Row topRow( 
    String title, 
    String address, MemoryImage image, 
    String number, 
    String orderDate,
    String method  ){
    return pw.Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        pw.Image(image),
        pw.Column(
          children: [
            pwtextoDosis(title, 28, fontWeight: pw.FontWeight.bold),
            pwtextoDosis(address, 25),
            pwboldLabel( 'Número: ', number, 23),
            pwboldLabel( 'Fecha: ', orderDate, 23),
            pwtextoDosis(( method == 'CUP' )
            ? 'Pago en Moneda Nacional ( CUP )'
            : (method == 'MLC')
              ? 'Transferencia de Moneda Libremente Convertible ( MLC )'
              : (method == 'USD')
                ? 'Pago en efectivo de Dólar Estadounidense ( USD )'
                : 'Transferencia Bancaria Directa USD ( ZELLE )', 23)
          ]
        )
      ]
    );
  }
  
  static Row infoRow( OrderInvoice invoice ){
    return pw.Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pwtextoDosis('Quién recibe la compra', 25, fontWeight: pw.FontWeight.bold),
            pwboldLabel('Nombre Completo: ', invoice.buyerName, 23),
            pwboldLabel('Carnet de Identidad: ', invoice.buyerCi, 23),
            pwboldLabel('Dirección: ', invoice.buyerAddress, 23),
            pwboldLabel('Teléfono de Contacto: ', invoice.buyerPhone, 23),
            pwboldLabel('Forma de Gestión Económica: ', invoice.buyerEconomic, 23),
          ]
        ),
        (invoice.payeerName != '')
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              pwtextoDosis('Quién realiza el pago', 25, fontWeight: pw.FontWeight.bold),
              pwboldLabel('Nombre Completo: ', invoice.payeerName, 23),
              pwboldLabel('Dirección: ', invoice.payeerAddress, 23),
              pwboldLabel('Código Postal: ', invoice.payeerPostalCode, 23),
              pwboldLabel('Teléfono de Contacto: ', invoice.payeerPhone, 23),
            ]
          ) : Container()
      ]
    );
  }

  static Widget buildInvoice(OrderInvoice invoice) {
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
        Container(child: pwtextoDosis('${item.price.numFormat} ${item.coin}', 23)),
        Container(child: pwtextoDosis('${(item.cantToBuy * item.price).numFormat} ${item.coin}', 23)),
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
          previousValue + element.price).numFormat} ${invoice.paymentMethod}', 23,
          fontWeight: FontWeight.bold)),
      Container(
        child: pwtextoDosis('${invoice.productList.fold(0.0, (previousValue, element) => 
          previousValue + element.cantToBuy * element.price).numFormat} ${invoice.paymentMethod}', 23,
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
