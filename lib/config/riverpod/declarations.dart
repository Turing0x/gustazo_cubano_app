import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/shared/Coin%20Prices/coin_prices_bloc.dart';
import 'package:gustazo_cubano_app/shared/Select_date/select_date_bloc.dart';

ValueNotifier<bool> authStatus = ValueNotifier<bool>(false);
ValueNotifier<bool> reloadProducts = ValueNotifier<bool>(false);
ValueNotifier<bool> reloadShoppingCart = ValueNotifier<bool>(false);
ValueNotifier<bool> reloadUsers = ValueNotifier<bool>(false);
ValueNotifier<bool> cambioListas = ValueNotifier<bool>(false);


final janddateR = StateNotifierProvider<JAndDateProvider, JAndDateModel>(
    (ref) => JAndDateProvider());

final coinPrices = StateNotifierProvider<CoinPricesProvider, CoinPricesModel>(
    (ref) => CoinPricesProvider());

final btnManagerR = StateProvider<bool>((ref) => false);