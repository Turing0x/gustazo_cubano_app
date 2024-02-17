import 'package:isar/isar.dart';

part 'login_data.g.dart';

@collection
class LoginData {
  Id id = Isar.autoIncrement;

  String? role;
  String? userID;
  String? commercialCode;
  String? token;
  String? ci;
  String? fullName;
  String? phone;
  String? address;

  @override
  String toString() {
    return '\nid: $id \nrole: $role \nuserID: $userID \nfullName: $fullName \ncommercialCode: $commercialCode \ntoken: $token \nci: $ci \nphone: $phone \naddress: $address';
  }
}
