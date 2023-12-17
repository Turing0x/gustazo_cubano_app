import 'dart:convert';

Product productFromJson(String str) => Product.fromJson(json.decode(str));

String productToJson(Product data) => json.encode(data.toJson());

class Product {
  final String id;
  final String name;
  final String description;
  final String photo;
  final double price;
  final double inStock;
  final double commission;
  final Discount discount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.photo,
    required this.price,
    required this.inStock,
    required this.commission,
    required this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
    photo: json["photo"],
    price: json["price"]?.toDouble(),
    inStock: json["in_stock"]?.toDouble(),
    commission: json["commission"]?.toDouble(),
    discount: Discount.fromJson(json["discount"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
    "photo": photo,
    "price": price,
    "in_stock": inStock,
    "commission": commission,
    "discount": discount.toJson(),
  };
}

class Discount {
  final int moreThan;
  final double discount;

  Discount({
    required this.moreThan,
    required this.discount,
  });

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
    moreThan: json["more_than"],
    discount: json["discount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "more_than": moreThan,
    "discount": discount,
  };
}