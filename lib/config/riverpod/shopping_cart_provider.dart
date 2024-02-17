import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';

Map<String, Product> _productList = {};

class ShoppingCartProvider extends StateNotifier<Product> {
  ShoppingCartProvider() : super(Product());

  Map<String, Product> get products {
    return {..._productList};
  }

  int get productsCant {
    int total = 0;
    _productList.forEach((key, value) {
      total += value.cantToBuy;
    });
    return total;
  }

  String whatCoin() {
    List<String> coins = ['CUP', 'USD', 'MLC', 'ZELLE'];
    return coins.firstWhere(
      (coin) => products.values.every((element) => element.coin == coin),
      orElse: () => 'CUP',
    );
  }

  double get totalAmount {
    double totalAmount = 0.0;
    _productList.forEach((key, value) {
      double price = value.cantToBuy >= value.moreThan ? value.discount : value.price;
      totalAmount += price * value.cantToBuy;
    });
    return totalAmount;
  }

  double totalCommissionMoney(WidgetRef ref) {
    double commissionMoney = 0.0;
    final prices = ref.watch(coinPrices);

    _productList.forEach((key, value) {
      double commission = value.cantToBuy >= value.moreThan ? value.commissionDiscount : value.commission;

      commissionMoney += (value.coin == 'CUP')
          ? value.cantToBuy * commission
          : (value.coin == 'MLC')
              ? (value.cantToBuy * commission) * prices.mlc
              : (value.cantToBuy * commission) * prices.usd;
    });

    return commissionMoney;
  }

  bool isInCart(String productId) => _productList.containsKey(productId);

  void addProductToList(Product product) {
    if (product.inStock < product.cantToBuy + 1) return;

    if (_productList.containsKey(product.id)) {
      _productList.update(
          product.id,
          (value) => Product(
              id: value.id,
              name: value.name,
              description: value.description,
              moreThan: value.moreThan,
              photo: value.photo,
              price: value.price,
              coin: value.coin,
              inStock: value.inStock,
              commission: value.commission,
              commissionDiscount: value.commissionDiscount,
              discount: value.discount,
              cantToBuy: value.cantToBuy + 1));
    } else {
      _productList.addAll({product.id: product});
    }
  }

  void addProductToListOnEditing(Product product) {
    _productList.addAll({product.id: product});
  }

  void removeProductFromList(String prodId) {
    _productList.remove(prodId);
  }

  void decreaseCantToBuyOfAProduct(String productId) {
    if (_productList[productId]!.cantToBuy != 1) {
      _productList.update(
          productId,
          (value) => Product(
              id: value.id,
              name: value.name,
              description: value.description,
              moreThan: value.moreThan,
              photo: value.photo,
              price: value.price,
              coin: value.coin,
              inStock: value.inStock,
              commissionDiscount: value.commissionDiscount,
              commission: value.commission,
              discount: value.discount,
              cantToBuy: value.cantToBuy - 1));
    }
  }

  void decreaseTenCantToBuyOfAProduct(String productId) {
    if (_productList[productId]!.cantToBuy - 10 > 1) {
      _productList.update(
          productId,
          (value) => Product(
              id: value.id,
              name: value.name,
              description: value.description,
              moreThan: value.moreThan,
              photo: value.photo,
              price: value.price,
              coin: value.coin,
              inStock: value.inStock,
              commissionDiscount: value.commissionDiscount,
              commission: value.commission,
              discount: value.discount,
              cantToBuy: value.cantToBuy - 10));
    }
  }

  void addTenCantToBuyOfAProduct(String productId) {
    Product product = _productList[productId]!;
    if (product.inStock < product.cantToBuy + 10) return;

    _productList.update(
        product.id,
        (value) => Product(
            id: value.id,
            name: value.name,
            description: value.description,
            moreThan: value.moreThan,
            photo: value.photo,
            price: value.price,
            coin: value.coin,
            inStock: value.inStock,
            commissionDiscount: value.commissionDiscount,
            commission: value.commission,
            discount: value.discount,
            cantToBuy: value.cantToBuy + 10));
  }

  int cantOfAProduct(String productId) {
    Product product = _productList[productId]!;
    return product.cantToBuy;
  }

  void cleanCart() => _productList = {};
  bool isEmpty() => _productList.isEmpty;
}
