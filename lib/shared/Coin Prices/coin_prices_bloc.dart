import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoinPricesProvider extends StateNotifier<CoinPricesModel> {
  CoinPricesProvider() : super(CoinPricesModel(mlc: 0.0, usd: 0.0));

  void setMlc(double price) {
    state = state.copyWith(mlc: price);
  }

  void setUsd(double price) {
    state = state.copyWith(usd: price);
  }
}

class CoinPricesModel {
  final double mlc;
  final double usd;

  CoinPricesModel({
    required this.mlc,
    required this.usd,
  });

  copyWith({
    double? mlc,
    double? usd,
  }) {
    return CoinPricesModel(
      mlc: mlc ?? this.mlc,
      usd: usd ?? this.usd,
    );
  }
}
