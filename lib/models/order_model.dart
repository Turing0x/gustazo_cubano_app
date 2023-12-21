import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  final String id;
  final String invoiceNumber;
  final bool finish;
  final DateTime date;
  final List<ProductList> productList;
  final double totalAmount;
  final double commision;
  final Seller seller;

  Order({
    required this.id,
    required this.invoiceNumber,
    required this.finish,
    required this.date,
    required this.productList,
    required this.totalAmount,
    required this.commision,
    required this.seller,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"],
    invoiceNumber: json["invoice_number"],
    finish: json["finish"],
    date: DateTime.parse(json["date"]),
    productList: List<ProductList>.from(json["product_list"].map((x) => ProductList.fromJson(x))),
    totalAmount: json["total_amount"]?.toDouble(),
    commision: json["commision"]?.toDouble(),
    seller: Seller.fromJson(json["seller"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "invoice_number": invoiceNumber,
    "finish": finish,
    "date": date.toIso8601String(),
    "product_list": List<dynamic>.from(productList.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "commision": commision,
    "seller": seller.toJson(),
  };

  int get getCantOfProducts {
    int total = 0;
    for (var element in productList) {
      total += element.cantToBuy;
    }
    return total;
  }
}

class ProductList {
  final String name;
  final double price;
  final int cantToBuy;
  final double commision;

  ProductList({
    required this.name,
    required this.price,
    required this.cantToBuy,
    required this.commision,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
    name: json["name"],
    price: json["price"]?.toDouble(),
    cantToBuy: json["cantToBuy"],
    commision: json["commision"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "cantToBuy": cantToBuy,
    "commision": commision,
  };
}

class Seller {
  final String fullName;
  final String referalCode;

  Seller({
    required this.fullName,
    required this.referalCode,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    fullName: json["fullName"],
    referalCode: json["referalCode"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "referalCode": referalCode,
  };
}
