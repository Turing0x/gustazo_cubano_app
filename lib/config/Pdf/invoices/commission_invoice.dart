import 'package:gustazo_cubano_app/models/order_model.dart';

class CommissionInvoice {
  final String title = 'E Gustazo Cubano';
  final String address = 'Ave 51 No 18004 Apto 9 e/ 180 y 190 La Lisa';

  final String userName;
  final String userCi;
  final String userAddress;
  final String userPhone;

  final List<Order> orderList;

  CommissionInvoice(
      {required this.userName,
      required this.userAddress,
      required this.userCi,
      required this.userPhone,
      required this.orderList});
}
