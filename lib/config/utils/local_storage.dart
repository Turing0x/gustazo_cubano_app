import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class LocalStorage {

  final _storage = const FlutterSecureStorage();

  // SAVE
  tokenSave(String token) async {
    _storage.write(key: 'access-token', value: token);
  }

  roleSave(String role) async {
    _storage.write(key: 'role', value: role);
  }

  userIdSave(String id) async {
    _storage.write(key: 'userID', value: id);
  }

  commercialCodeSave(String code) async {
    _storage.write(key: 'commercialCode', value: code);
  }

  ciSave(String ci) async {
    _storage.write(key: 'ci', value: ci);
  }

  fullNameSave(String name) async {
    _storage.write(key: 'name', value: name);
  }

  phoneSave(String phone) async {
    _storage.write(key: 'phone', value: phone);
  }

  // ----------------------------------------------------------

  // GET
  static Future<String?> gettoken() async {
    final token = await storage.read(key: 'access-token');
    return token;
  }

  static Future<String?> getrole() async {
    final token = await storage.read(key: 'role');
    return token;
  }

  static Future<String?> getuserId() async {
    final userId = await storage.read(key: 'userID');
    return userId;
  }

  static Future<String?> getcommercialCode() async {
    final userId = await storage.read(key: 'commercialCode');
    return userId;
  }

  static Future<String?> getci() async {
    final token = await storage.read(key: 'ci');
    return token;
  }

  static Future<String?> getfullName() async {
    final passOffline = await storage.read(key: 'name');
    return passOffline;
  }

  static Future<String?> getphone() async {
    final passOffline = await storage.read(key: 'phone');
    return passOffline;
  }

  // ----------------------------------------------------------

  // DELETE
  static Future<void> tokenDelete() async {
    await storage.delete(key: 'access-token');
  }

  static Future<void> roleDelete() async {
    await storage.delete(key: 'role');
  }

  static Future<void> userIdDelete() async {
    await storage.delete(key: 'userID');
  }

  static Future<void> commercialCodeDelete() async {
    await storage.delete(key: 'commercialCode');
  }

  static Future<void> ciDelete() async {
    await storage.delete(key: 'ci');
  }

  static Future<void> fullNameDelete() async {
    await storage.delete(key: 'name');
  }

  static Future<void> phoneDelete() async {
    await storage.delete(key: 'phone');
  }

}