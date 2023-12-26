import 'dart:convert';

import 'package:gustazo_cubano_app/models/product_model.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  final String id;
  final String invoiceNumber;
  final bool finish;
  final DateTime date;
  final List<Product> productList;
  final double totalAmount;
  final double commission;
  final Seller seller;

  Order({
    required this.id,
    required this.invoiceNumber,
    required this.finish,
    required this.date,
    required this.productList,
    required this.totalAmount,
    required this.commission,
    required this.seller,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"] ?? '',
    invoiceNumber: json["invoice_number"] ?? '',
    finish: json["finish"],
    date: DateTime.parse(json["date"]),
    productList: List<Product>.from(json["product_list"].map((x) => Product.fromJson(x))),
    totalAmount: json["total_amount"]?.toDouble(),
    commission: json["commission"]?.toDouble(),
    seller: Seller.fromJson(json["seller"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "invoice_number": invoiceNumber,
    "finish": finish,
    "date": date.toIso8601String(),
    "product_list": List<Product>.from(productList.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "commission": commission,
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
