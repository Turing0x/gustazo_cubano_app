import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';

Map<String, Product> _productList = {};
class ShoppingCartProvider extends StateNotifier<Product> {

  ShoppingCartProvider() : super(Product());

  Map<String, Product> get products {
    return { ..._productList };
  }

  int get productsCant {
    int total = 0;
    _productList.forEach((key, value) {
      total += value.cantToBuy;
    });
    return total;
  }

  double get totalAmount {
    double totalAmount = 0.0;
    _productList.forEach((key, value) => 
      totalAmount += value.price * value.cantToBuy );
    return totalAmount;
  }

  double get totalCommisionMoney {
    double commisionMoney = 0.0;
    _productList.forEach((key, value) => 
      commisionMoney += (value.price * value.cantToBuy) * (value.commission / 100) );
    return commisionMoney;
  }

  bool isInCart(String productId) => _productList.containsKey(productId);

  void addProductToList( Product product ){
    if( _productList.containsKey(product.id) ){
      _productList.update(product.id, (value) => Product(
        id: value.id, 
        name: value.name, 
        description: value.description, 
        photo: value.photo, 
        price: value.price, 
        inStock: value.inStock, 
        commission: value.commission, 
        discount: value.discount,
        cantToBuy: value.cantToBuy + 1
      ));
    }else {
      _productList.addAll({
        product.id: product
      });
    }
  }

  void removeProductFromList (String prodId) {
    _productList.remove(prodId);
  }

  void decreaseCantToBuyOfAProduct( String productId ){
    if(_productList[productId]!.cantToBuy == 1){
      removeProductFromList(productId);
    }else {
      _productList.update(productId, (value) => Product(
        id: value.id, 
        name: value.name, 
        description: value.description, 
        photo: value.photo, 
        price: value.price, 
        inStock: value.inStock, 
        commission: value.commission, 
        discount: value.discount,
        cantToBuy: value.cantToBuy - 1
      ));
    }
  }

  int cantOfAProduct(String productId){
    Product product = _productList[productId]!;
    return product.cantToBuy;
  }

  void cleanCart() => _productList = {};
  bool isEmpty() => _productList.isEmpty;

}