
import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/pages/Admin/orders_history_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/my_orders_history_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/my_pendings_today_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/to_make_shopping_cart_page.dart';
import 'package:gustazo_cubano_app/pages/Order/pendigns_control_page.dart';
import 'package:gustazo_cubano_app/pages/Commercial/finish_order_page.dart';
import 'package:gustazo_cubano_app/pages/Product/add_products_on_editing.dart';
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
  'orders_history_page': (_) => const OrdersHistoryPage(),
  
  'commercials_control_page': (_) => const CommercialsControlPage(),
  'to_make_shopping_cart_page': (_) => const ToMakeShoppingCartPage(),
  'finish_order_page': (_) => const FinishOrderPage(),
  'my_pendings_today_page': (_) => const MyPendignsTodayPage(),
  'my_orders_history_page': (_) => const MyOrdersHistoryPage(),

  'stock_control_page': (_) => const StockControlPage(),
  'create_product_page': (_) => const CreateProductPage(),
  'shopping_cart_page': (_) => const ShoppingCartPage(),
  'add_products_on_editing': (_) => const AddProductsOnEditing(),

};
