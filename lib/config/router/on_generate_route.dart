import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/pages/Admin/order_details_page.dart';
import 'package:gustazo_cubano_app/pages/Order/confirm_pending_page.dart';
import 'package:gustazo_cubano_app/pages/Order/edit_pending_page.dart';
import 'package:gustazo_cubano_app/pages/Order/pending_details_page.dart';
import 'package:gustazo_cubano_app/pages/Product/product_detail.dart';

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
    
  };

  return argRoutes[settings.name];

}