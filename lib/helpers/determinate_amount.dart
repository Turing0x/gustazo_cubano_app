import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';

String calculatePurchaseAmount(WidgetRef ref, String coin, double price) {
  final prices = ref.watch(coinPrices);
  if(coin == 'CUP') return price.toStringAsFixed(2);
  if(coin == 'MLC') return (price / prices.mlc).toStringAsFixed(2);
  return (price / prices.usd).toStringAsFixed(2);
}

String calculateCommission(WidgetRef ref, String coin, double total){
  final prices = ref.watch(coinPrices);
  if(coin == 'CUP') return total.toStringAsFixed(2);
  if(coin == 'MLC') return (total * prices.mlc).toStringAsFixed(2);
  return (total * prices.usd).toStringAsFixed(2);
}