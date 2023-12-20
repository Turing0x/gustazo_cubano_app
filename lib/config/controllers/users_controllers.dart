import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/config/utils/local_storage.dart';
import 'package:gustazo_cubano_app/models/user_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class UserControllers {

  final _dio = Dio(
    BaseOptions(
      baseUrl: Uri.http(dotenv.env['SERVER_URL']!).toString(),
      headers: { 'Content-Type': 'application/json' }
    )
  );

  Future<List<User>> getAllCommercials() async{

    try {

      Response response = await _dio.get('/api/users',
        options: Options(validateStatus: (status) => true));

      if( response.statusCode == 500 ) return [];

      List<User> list = [];

      response.data['data'].forEach((value) {
        final userTemp = User.fromJson(value);
        list.add(userTemp);
      });

      return list;
      
    } catch (_) {
      return [];
    }

  }

  Future<String> login(String username, String pass) async {
    authStatus.value = true;
    try {

      final localStorage = LocalStorage();

      Response response = await _dio.post('/api/users/signin',
        data: jsonEncode({'username': username, 'password': pass}),
        options: Options(validateStatus: (status) => true));

      authStatus.value = false;

      if (response.statusCode == 200) {
        String role = response.data['data']['role'];

        localStorage.usernameSave(username);
        localStorage.userIdSave(response.data['data']['userID']);
        localStorage.fullNameSave(response.data['data']['fullName']);
        localStorage.referalCodeSave(response.data['data']['referalCode']);
        localStorage.tokenSave(response.data['data']['token']);
        localStorage.timeSignSave(DateTime.now().toString());
        localStorage.roleSave(role);

        showToast(response.data['api_message'], type: true);
        return role;
      }

      showToast(response.data['api_message']);

      return '';
    } on Exception catch (_) {
      authStatus.value = false;
      return '';
    }
  }

  Future<bool> changeEnable(String id, bool enable) async {
    try {

      Response response = await _dio.put('/api/users/changeEnable/$id',
        data: jsonEncode({ 'enable': enable }),
        options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        showToast(response.data['api_message'], type: true);
        return true;
      }

      showToast(response.data['api_message']);
      return false;
    } catch (e) {
      showToast('Ha ocrrido un error grave');
      return false;
    }
  }

  void saveUser(String username, String password) async {
    try {

      Response response = await _dio.post('/api/users', 
        data: jsonEncode({'username': username, 'password': password}), 
        options: Options(validateStatus: (status) => true) );

      if (response.statusCode == 200) {
        showToast(response.data['api_message'], type: true);
        return;
      }

      showToast(response.data['api_message']);
      return;
    } on Exception catch (e) {
      showToast(e.toString());
    }
  }
  
  void resetPass(String userId) async {
    try {
      final queryData = {'userId': userId};

      Response response = await _dio.post('/api/users/resetpass', 
        queryParameters: queryData, 
        options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        showToast(response.data['api_message'], type: true);
        return;
      }

      showToast(response.data['api_message']);
      return;
    } on Exception catch (e) {
      showToast(e.toString());
    }
  }

  void deleteOne(String id) async {
    try {

      Response response = await _dio.delete('/api/users/$id', 
        options: Options(validateStatus: (status) => true));
        
      if (response.statusCode == 200) {
        showToast(response.data['api_message'], type: true);
        return;
      }

      showToast(response.data['api_message']);
      return;
    } catch (e) {
      return;
    }
  }

}