import 'package:gustazo_cubano_app/models/order_model.dart';

class CommisionInvoce {

  final String title = 'Ventas Kapricho';
  final String address = 'Calle 222 e/ 29 y 31 La Coronela. La Lisa';

  final String userName;
  final String userCi;
  final String userAddress;
  final String userPhone;
  
  final List<Order> orderList;

  CommisionInvoce({
    required this.userName, 
    required this.userAddress,
    required this.userCi, 
    required this.userPhone, 
    required this.orderList
  });

}