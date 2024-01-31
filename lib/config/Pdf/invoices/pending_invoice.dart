import 'package:gustazo_cubano_app/models/product_model.dart';

class PendingInvoice {

  final String title = 'Ventas Kapricho';
  final String address = 'Calle 222 e/ 29 y 31 La Coronela. La Lisa';

  final String paymentMethod;

  final String buyerName;
  final String buyerAddress;
  final String buyerCi;
  final String buyerPhone;
  final String buyerEconomic;
  
  final String orderNumber;
  final String orderDate;
  final String pendingNumber;

  final List<Product> productList;

  PendingInvoice({
    required this.paymentMethod, 
    required this.buyerName, 
    required this.pendingNumber, 
    required this.buyerAddress, 
    required this.buyerCi, 
    required this.buyerPhone, 
    required this.buyerEconomic, 
    required this.orderNumber, 
    required this.orderDate, 
    required this.productList
  });

}