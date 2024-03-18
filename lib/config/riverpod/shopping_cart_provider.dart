import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';

final cartProvider = ChangeNotifierProvider((ref) => ShoppingCartProvider());

class ShoppingCartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get totalProductCount {
    int totalCount = 0;
    for (var item in _items) {
      totalCount += item.product.cantToBuy * item.quantity;
    }
    return totalCount;
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      double itemPrice = item.product.price;
      if (item.product.cantToBuy >= item.product.moreThan) {
        itemPrice = item.product.discount;
      }
      if (item.product.sellType == 'Caja') {
        itemPrice *= item.product.box;
      } else if (item.product.sellType == 'Peso') {
        itemPrice *= item.product.weigth;
      }
      total += itemPrice * item.quantity;
    }
    return total;
  }

  double get totalCommission {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.commission * item.quantity;
    }
    return total;
  }

  String whatCoin() {
    List<String> coins = ['CUP', 'USD', 'MLC', 'ZELLE'];
    return coins.firstWhere(
      (coin) => _items.every((element) => element.product.coin == coin),
      orElse: () => 'CUP',
    );
  }

  void addToCart(Product product) {
    _items.add(CartItem(product: product));
    notifyListeners();
  }

  void removeFromCartById(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void increaseQuantityById(String productId, {int amount = 1}) {

    final item = _items.firstWhere((item) => 
      item.product.id == productId, 
      orElse: () => CartItem(product: Product(id: productId)));

    if (item.quantity + amount <= 10) {
      item.quantity += amount;
    } else {
      item.quantity = 10;
    }
    notifyListeners();
  }

  void decreaseQuantityById(String productId, {int amount = 1}) {

    final item = _items.firstWhere((item) => 
      item.product.id == productId, 
      orElse: () => CartItem(product: Product(id: productId)));

    if (item.quantity - amount >= 1) {
      item.quantity -= amount;
    } else {
      removeFromCartById(productId);
    }
    notifyListeners();
  }
  
  int cantOfAProduct(String productId) {
    final item = _items.firstWhere((item) => item.product.id == productId, 
      orElse: () => CartItem(product: Product(id: productId)));
    return item.quantity;
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}