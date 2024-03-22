import 'dart:convert';

Coin coinFromJson(String str) => Coin.fromJson(json.decode(str));

String coinToJson(Coin data) => json.encode(data.toJson());

class Coin {
  final String id;
  final double mlc;
  final double usd;

  Coin({
    required this.id,
    required this.mlc,
    required this.usd,
  });

  factory Coin.fromJson(Map<String, dynamic> json) => Coin(
        id: json["_id"] ?? '',
        mlc: json["mlc"].toDouble() ?? 0.0,
        usd: json["usd"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mlc": mlc,
        "usd": usd,
      };
}
