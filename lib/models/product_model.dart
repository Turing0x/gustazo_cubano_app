import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  final String id;
  final String name;
  final String description;
  final String provider;
  final String photo;
  final double price;
  final String coin;
  final double commission;
  final double commissionDiscount;
  final double discount;
  final int inStock;
  final int cantToBuy;
  final int moreThan;

  Product({
    this.id = '',
    this.name = '',
    this.description = '',
    this.provider = '',
    this.coin = '',
    this.photo = '',
    this.price = 0,
    this.inStock = 0,
    this.commission = 0,
    this.commissionDiscount = 0,
    this.moreThan = 0,
    this.discount = 0,
    this.cantToBuy = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"] ?? '',
    name: json["name"] ?? '',
    description: json["description"] ?? '',
    provider: json["provider"] ?? '',
    photo: json["photo"] ?? '',
    coin: json["coin"] ?? '',
    price: json["price"]?.toDouble() ?? 0,
    commission: json["commission"]?.toDouble() ?? 0,
    commissionDiscount: json["commissionDiscount"]?.toDouble() ?? 0,
    discount: json["discount"]?.toDouble() ?? 0,
    moreThan: json["more_than"]?.toInt() ?? 0,
    inStock: json["in_stock"]?.toInt() ?? 0,
    cantToBuy: json["cantToBuy"]?.toInt() ?? 1,
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "provider": provider,
    "photo": photo,
    "coin": coin,
    "price": price,
    "in_stock": inStock,
    "commission": commission,
    "commissionDiscount": commissionDiscount,
    "more_than": moreThan,
    "discount": discount,
    "cantToBuy": cantToBuy,
  };

  @override
  String toString() {
    return 'Product: { \nid: $id, \nname: $name, \ndescription: $description, \nprovider: $provider, \ncoin: $coin, \nphoto: $photo, \nprice: $price, \ninStock: $inStock, \ncantToBuy: $cantToBuy, \nmoreThan: $moreThan, \ncommission: $commission, \ndiscount: $discount}';
  }
  
}

class ProductCart {

  final String name;
  final double price;
  final int cantToBuy;

  ProductCart({
    this.name = '',
    this.price = 0,
    this.cantToBuy = 1,
  });

  factory ProductCart.fromJson(Map<String, dynamic> json) => ProductCart(
    name: json["name"],
    price: json["price"]?.toDouble(),
    cantToBuy: json["cantToBuy"]?.toInt(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "cantToBuy": cantToBuy,
  };

  @override
  String toString() {
    return 'ProductCart: {name: $name, price: $price, cantToBuy: $cantToBuy}';
  }

}