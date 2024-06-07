import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));
String productToJson(Product data) => json.encode(data.toJson());

class Product {
  final String id;
  final String name;
  final String description;
  final String provider;
  final String photo;
  final String coin;
  final String sellType;
  final String weigthType;

  final double price;
  final double weigth;
  final double discount;
  
  final int inStock;
  final int box;
  final int commission;
  final int commissionDiscount;
  final int moreThan;
  int cantToBuy;

  Product({
    this.id = '',
    this.name = '',
    this.description = '',
    this.provider = '',
    this.photo = '',
    this.weigthType = '',
    this.price = 0,
    this.coin = '',
    this.sellType = '',
    this.box = 0,
    this.weigth = 0,
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
      price: json["price"]?.toDouble() ?? 0,
      coin: json["coin"] ?? '',
      sellType: json["sellType"] ?? '',
      weigthType: json["weigthType"] ?? '',
      box: json["box"] ?? 0,
      weigth: json["weigth"]?.toDouble() ?? 0,
      inStock: json["in_stock"] ?? 0,
      commission: json["commission"] ?? '',
      commissionDiscount: json["commissionDiscount"] ?? '',
      moreThan: json["more_than"] ?? '',
      discount: json["discount"]?.toDouble() ?? 0,
      cantToBuy: json["cantToBuy"] ?? 1
  );

  Map<String, dynamic> toJson() => {
      "_id": id,
      "name": name,
      "description": description,
      "provider": provider,
      "photo": photo,
      "price": price,
      "weigthType": weigthType,
      "coin": coin,
      "sellType": sellType,
      "box": box,
      "weigth": weigth,
      "in_stock": inStock,
      "commission": commission,
      "commissionDiscount": commissionDiscount,
      "more_than": moreThan,
      "discount": discount,
      "cantToBuy": cantToBuy,
  };
}
