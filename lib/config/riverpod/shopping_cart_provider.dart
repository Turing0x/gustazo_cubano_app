import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';

final cartProvider = ChangeNotifierProvider((ref) => ShoppingCartProvider());

class ShoppingCartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  int get totalProductCount {
    int totalCount = 0;
    for (var item in _items) {
      totalCount += item.cantToBuy;
    }
    return totalCount;
  }

  double get totalAmount {
   double total = 0.0;
   for (var item in _items) {
      double itemPrice = item.price;
      if (item.cantToBuy >= item.moreThan) {
        itemPrice = item.discount;
      }
      if(item.sellType == 'weight'){
        itemPrice *= item.weigth;
      }
      if(item.sellType == 'box'){
        itemPrice *= item.box;
      }
      total += itemPrice * item.cantToBuy;
   }
   return total;
  }

  double get totalCommission {
    double total = 0.0;
    for (var item in _items) {
      total += item.commission * item.cantToBuy;
    }
    return total;
  }

  String whatCoin() {
    List<String> coins = ['CUP', 'USD', 'MLC', 'ZELLE'];
    return coins.firstWhere(
      (coin) => _items.every((element) => element.coin == coin),
      orElse: () => 'CUP',
    );
  }

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeFromCartById(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void increaseQuantityById(String productId, {int amount = 1}) {

    final item = _items.firstWhere((item) => 
      item.id == productId, 
      orElse: () => Product(id: productId));

    if (item.cantToBuy + amount <= 10) {
      item.cantToBuy += amount;
    } else {
      item.cantToBuy = 10;
    }
    notifyListeners();
  }

  void decreaseQuantityById(String productId, {int amount = 1}) {

    final item = _items.firstWhere((item) => 
      item.id == productId, 
      orElse: () => Product(id: productId));

    if (item.cantToBuy - amount >= 1) {
      item.cantToBuy -= amount;
    } else {
      removeFromCartById(productId);
    }
    notifyListeners();
  }
  
  int cantOfAProduct(String productId) {
    final item = _items.firstWhere((item) => item.id == productId, 
      orElse: () => Product(id: productId));
    return item.cantToBuy;
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.id == productId);
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

