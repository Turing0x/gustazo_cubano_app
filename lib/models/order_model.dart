import 'dart:convert';

import 'package:gustazo_cubano_app/models/product_model.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  final String id;
  final bool finish;
  final String invoiceNumber;
  final DateTime date;
  final List<Product> productList;
  final int totalAmount;
  final double commission;
  final Seller seller;
  final Buyer buyer;
  final String pendingNumber;

  Order({
    required this.id,
    required this.finish,
    required this.invoiceNumber,
    required this.date,
    required this.productList,
    required this.totalAmount,
    required this.commission,
    required this.seller,
    required this.buyer,
    required this.pendingNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"],
    finish: json["finish"],
    invoiceNumber: json["invoice_number"],
    date: DateTime.parse(json["date"]),
    productList: List<Product>.from(json["product_list"].map((x) => Product.fromJson(x))),
    totalAmount: json["total_amount"],
    commission: json["commission"]?.toDouble(),
    seller: Seller.fromJson(json["seller"]),
    buyer: Buyer.fromJson(json["buyer"]),
    pendingNumber: json["pending_number"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "finish": finish,
    "invoice_number": invoiceNumber,
    "date": date.toIso8601String(),
    "product_list": List<dynamic>.from(productList.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "commission": commission,
    "seller": seller.toJson(),
    "buyer": buyer.toJson(),
    "pending_number": pendingNumber,
  };

  int get getCantOfProducts {
    int total = 0;
    for (var element in productList) {
      total += element.cantToBuy;
    }
    return total;
  }

}

class Buyer {
  final String fullName;
  final String ci;
  final String phoneNumber;
  final String address;

  Buyer({
    required this.fullName,
    required this.ci,
    required this.phoneNumber,
    required this.address,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
    fullName: json["full_name"],
    ci: json["ci"],
    phoneNumber: json["phone_number"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "ci": ci,
    "phone_number": phoneNumber,
    "address": address,
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