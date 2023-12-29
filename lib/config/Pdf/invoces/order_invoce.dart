import 'package:gustazo_cubano_app/models/product_model.dart';

class OrderInvoce {

  final String title = 'Ventas Kapricho';
  final String address = 'Calle 222 e/ 29 y 31 La Coronela. La Lisa';
  final String yadira = 'Yadira Sera Perez';
  final String email = 'yadiras2022@gmail.com';
  final String phone = '54757636';
  final String paymentMethod = 'Transferencia bancaria directa';
  
  final String invoiceNumber;
  final String invoiceDate;

  final String orderNumber;
  final String orderDate;

  final List<Product> productList;

  OrderInvoce({
    required this.invoiceNumber, 
    required this.invoiceDate, 
    required this.orderNumber, 
    required this.orderDate, 
    required this.productList
  });

}