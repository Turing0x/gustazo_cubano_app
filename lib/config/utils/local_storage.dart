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

  usernameSave(String username) async {
    _storage.write(key: 'username', value: username);
  }

  timeSignSave(String time) async {
    _storage.write(key: 'lastTime', value: time);
  }

  // ----------------------------------------------------------

  // GET
  static Future<String?> getToken() async {
    final token = await storage.read(key: 'access-token');
    return token;
  }

  static Future<String?> getUsername() async {
    final token = await storage.read(key: 'username');
    return token;
  }

  static Future<String?> getUserId() async {
    final userId = await storage.read(key: 'userID');
    return userId;
  }

  static Future<String?> getUserOwner() async {
    final userId = await storage.read(key: 'userOwner');
    return userId;
  }

  static Future<String?> getRole() async {
    final token = await storage.read(key: 'role');
    return token;
  }

  static Future<String?> getpassListerOffline() async {
    final passOffline = await storage.read(key: 'passListerOffline');
    return passOffline;
  }

  static Future<String?> getTimeSign() async {
    final passOffline = await storage.read(key: 'lastTime');
    return passOffline;
  }

  static Future<String?> getStatusBlock() async {
    final passOffline = await storage.read(key: 'lastEnable');
    return passOffline;
  }

  // ----------------------------------------------------------

  // DELETE
  static Future<void> tokenDelete() async {
    await storage.delete(key: 'access-token');
  }

  static Future<void> usernameDelete() async {
    await storage.delete(key: 'username');
  }

  static Future<void> userIdDelete() async {
    await storage.delete(key: 'userID');
  }

  static Future<void> userOwnerDelete() async {
    await storage.delete(key: 'userOwner');
  }

  static Future<void> roleDelete() async {
    await storage.delete(key: 'role');
  }

  static Future<void> timeSignDelete() async {
    await storage.delete(key: 'lastTime');
  }

  static Future<void> statusBlockDelete() async {
    await storage.delete(key: 'lastEnable');
  }

}