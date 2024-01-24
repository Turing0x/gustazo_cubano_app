import 'dart:convert';

import 'package:gustazo_cubano_app/models/product_model.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  final String id;
  final bool finish;
  final String invoiceNumber;
  final String pendingNumber;
  final DateTime date;
  final List<Product> productList;
  final int totalAmount;
  final int commission;
  final Seller seller;
  final Buyer buyer;
  final String typeCoin;
  final WhoPay whoPay;

  Order({
    required this.id,
    required this.finish,
    required this.invoiceNumber,
    required this.pendingNumber,
    required this.date,
    required this.productList,
    required this.totalAmount,
    required this.commission,
    required this.seller,
    required this.buyer,
    required this.typeCoin,
    required this.whoPay,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["_id"],
    finish: json["finish"],
    invoiceNumber: json["invoice_number"],
    pendingNumber: json["pending_number"],
    date: DateTime.parse(json["date"]),
    productList: List<Product>.from(json["product_list"].map((x) => Product.fromJson(x))),
    totalAmount: json["total_amount"],
    commission: json["commission"],
    seller: Seller.fromJson(json["seller"]),
    buyer: Buyer.fromJson(json["buyer"]),
    typeCoin: json["type_coin"],
    whoPay: WhoPay.fromJson(json["who_pay"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "finish": finish,
    "invoice_number": invoiceNumber,
    "pending_number": pendingNumber,
    "date": date.toIso8601String(),
    "product_list": List<dynamic>.from(productList.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "commission": commission,
    "seller": seller.toJson(),
    "buyer": buyer.toJson(),
    "type_coin": typeCoin,
    "who_pay": whoPay.toJson(),
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
  final String economic;
  final String fullName;
  final String ci;
  final String phoneNumber;
  final String address;

  Buyer({
    required this.economic,
    required this.fullName,
    required this.ci,
    required this.phoneNumber,
    required this.address,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
    economic: json["economic"],
    fullName: json["full_name"],
    ci: json["ci"],
    phoneNumber: json["phone_number"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "economic": economic,
    "full_name": fullName,
    "ci": ci,
    "phone_number": phoneNumber,
    "address": address,
  };
}

class Seller {
  final String commercialCode;
  final String ci;
  final String fullName;
  final String phone;
  final String address;

  Seller({
    required this.commercialCode,
    required this.ci,
    required this.fullName,
    required this.phone,
    required this.address,
  });

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
    commercialCode: json["commercial_code"],
    ci: json["ci"],
    fullName: json["full_name"],
    phone: json["phone"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "commercial_code": commercialCode,
    "ci": ci,
    "full_name": fullName,
    "phone": phone,
    "address": address,
  };
}

class WhoPay {
  final String fullName;
  final String postalCode;
  final String phoneNumber;
  final String address;

  WhoPay({
    required this.fullName,
    required this.postalCode,
    required this.phoneNumber,
    required this.address,
  });

  factory WhoPay.fromJson(Map<String, dynamic> json) => WhoPay(
    fullName: json["full_name"] ?? '',
    postalCode: json["postal_code"] ?? '',
    phoneNumber: json["phone_number"] ?? '',
    address: json["address"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "full_name": fullName,
    "postal_code": postalCode,
    "phone_number": phoneNumber,
    "address": address,
  };
}