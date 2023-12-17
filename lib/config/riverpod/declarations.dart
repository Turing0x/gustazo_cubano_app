import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';

ValueNotifier<bool> authStatus = ValueNotifier<bool>(false);
ValueNotifier<bool> reloadProducts = ValueNotifier<bool>(false);

final btnManagerR = StateProvider<bool>((ref) => false);

final chCant = StateProvider<int>((ref) => 0);
final chMoney = StateProvider<double>((ref) => 0);
final chProductList = StateProvider<List<Product>>((ref) => []);
