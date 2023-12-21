
import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/pages/Product/pendigns_control_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/finish_order_page.dart';
import 'package:gustazo_cubano_app/pages/Product/shopping_cart_page.dart';

import 'package:gustazo_cubano_app/pages/auth_page.dart';

import 'package:gustazo_cubano_app/pages/Admin/main_admin_page.dart';

import 'package:gustazo_cubano_app/pages/Commercial/commercials_control_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/main_commercial_page.dart';

import 'package:gustazo_cubano_app/pages/Product/stock_control_page.dart';
import 'package:gustazo_cubano_app/pages/Product/create_product_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'auth_page': (_) => const AuthPage(),

  'main_admin_page': (_) => const MainAdminPage(),
  'main_commercial_page': (_) => const MainCommercialPage(),
  'pendings_control_page': (_) => const PendignsControlPage(),
  
  'commercials_control_page': (_) => const CommercialsControlPage(),
  'finish_order_page': (_) => const FinishOrderPage(),

  'stock_control_page': (_) => const StockControlPage(),
  'create_product_page': (_) => const CreateProductPage(),
  'shopping_cart_page': (_) => const ShoppingCartPage(),

};
