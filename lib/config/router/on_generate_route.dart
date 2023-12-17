import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/pages/Product/product_detail.dart';

MaterialPageRoute<dynamic>? onGenerateRoute ( RouteSettings settings ) {

  final argumentos = settings.arguments as List;
  Map<String, MaterialPageRoute> argRoutes = {
    
    'product_detail_page': MaterialPageRoute(
      builder: (_) => ProductDetails(
        product: argumentos[0],
      )),
    
  };

  return argRoutes[settings.name];

}