import 'package:gustazo_cubano_app/models/product_model.dart';

class PendingInvoce {

  final String title = 'Ventas Kapricho';
  final String address = 'Calle 222 e/ 29 y 31 La Coronela. La Lisa';

  final String buyerName;
  final String buyerAddress;
  final String buyerCi;
  final String buyerPhone;
  
  final String orderNumber;
  final String orderDate;
  final String pendingNumber;

  final List<Product> productList;

  PendingInvoce({
    required this.buyerName, 
    required this.pendingNumber, 
    required this.buyerAddress, 
    required this.buyerCi, 
    required this.buyerPhone, 
    required this.orderNumber, 
    required this.orderDate, 
    required this.productList
  });

}