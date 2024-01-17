import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/pages/Admin/order_details_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/commercial_info_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/my_orders_history_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/my_pendings_today_page.dart';
import 'package:gustazo_cubano_app/pages/Order/buyer_info_page.dart';
import 'package:gustazo_cubano_app/pages/Order/confirm_pending_page.dart';
import 'package:gustazo_cubano_app/pages/Order/edit_pending_page.dart';
import 'package:gustazo_cubano_app/pages/Order/pending_details_page.dart';
import 'package:gustazo_cubano_app/pages/Product/product_detail.dart';
import 'package:gustazo_cubano_app/pages/Product/product_detail_page.dart';

MaterialPageRoute<dynamic>? onGenerateRoute ( RouteSettings settings ) {

  final argumentos = settings.arguments as List;
  Map<String, MaterialPageRoute> argRoutes = {
    
    'product_detail_page': MaterialPageRoute(
      builder: (_) => ProductDetails(
        product: argumentos[0],
      )),

    'pending_details_page': MaterialPageRoute(
      builder: (_) => PendingDetailsPage(
        order: argumentos[0],
      )),
      
    'order_details_page': MaterialPageRoute(
      builder: (_) => OrderDetailsPage(
        order: argumentos[0],
      )),

    'confirm_pending_page': MaterialPageRoute(
      builder: (_) => ConfirmPendingPage(
        orderId: argumentos[0],
      )),

    'edit_pending_page': MaterialPageRoute(
      builder: (_) => EditPendingPage(
        order: argumentos[0],
      )),

    'buyer_info_page': MaterialPageRoute(
      builder: (_) => BuyerInfoPage(
        dataOrder: argumentos[0],
      )),

    'my_pendings_today_page': MaterialPageRoute(
      builder: (_) => MyPendignsTodayPage(
        referalCode: argumentos[0],
      )),

    'my_orders_history_page': MaterialPageRoute(
      builder: (_) => MyOrdersHistoryPage(
        referalCode: argumentos[0],
      )),

    'product_details_page': MaterialPageRoute(
      builder: (_) => ProductDetailsPage(
        product: argumentos[0],
      )),

    'commercial_info_page': MaterialPageRoute(
      builder: (_) => CommercialInfoPage(
        commercial: argumentos[0],
      )),
    
  };

  return argRoutes[settings.name];

}