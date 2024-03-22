import 'package:gustazo_cubano_app/config/database/entities/login_data.dart';
import 'package:gustazo_cubano_app/config/database/isar.dart';
import 'package:isar/isar.dart';

class LoginDataService {
  late Future<Isar> db;

  LoginDataService() {
    db = IsarService().isar;
  }

  Future<List<LoginData>> getData() async {
    final isar = await db;
    return isar.loginDatas.where().findAll();
  }

  void saveData(LoginData data) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.loginDatas.where().deleteAll();
      await isar.loginDatas.put(data);
    });
  }

  // Getter of all Properties
  Future<String?> getRole() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].role != null) {
      return getter[0].role;
    }
    return '';
  }

  Future<String?> getUserID() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].userID != null) {
      return getter[0].userID;
    }
    return '';
  }

  Future<String?> getCi() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].ci != null) {
      return getter[0].ci;
    }
    return '';
  }

  Future<String?> getFullName() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].fullName != null) {
      return getter[0].fullName;
    }
    return '';
  }

  Future<String?> getPhone() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].phone != null) {
      return getter[0].phone;
    }
    return '';
  }

  Future<String?> getAddress() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].address != null) {
      return getter[0].address;
    }
    return '';
  }

  Future<String?> getCommercialCode() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].commercialCode != null) {
      return getter[0].commercialCode;
    }
    return '';
  }

  Future<String?> getToken() async {
    final isar = await db;
    final getter = await isar.loginDatas.where().findAll();
    if (getter.isNotEmpty && getter[0].token != null) {
      return getter[0].token;
    }
    return '';
  }

  // Delete of all Properties
  void deleteData() async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.loginDatas.where().deleteAll();
    });
  }
}
