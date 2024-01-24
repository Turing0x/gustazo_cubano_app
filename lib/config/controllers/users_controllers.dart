import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/user_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class UserControllers {

  late Dio _dio;

  UserControllers() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final token = await LoginDataService().getToken();

    _dio = Dio(
      BaseOptions(
        baseUrl: Uri.http(dotenv.env['SERVER_URL']!).toString(),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token,
        },
        validateStatus: (status) => true,
      ),
    );
  }

  Future<List<User>> getAllCommercials() async{

    try {

      await _initializeDio();
      EasyLoading.show(status: 'Procesando información...');

      Response response = await _dio.get('/api/users',
        options: Options(validateStatus: (status) => true));

      if( response.statusCode == 500 ) {
        EasyLoading.showInfo('No se pudo cargar la información de los usuarios');
        return [];
      }

      if( response.data['data'].isEmpty ) {
        EasyLoading.showInfo('Los usuarios han sido cargados correctamente');
        return [];
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return [];
      }

      List<User> list = [];

      response.data['data'].forEach((value) {
        final userTemp = User.fromJson(value);
        list.add(userTemp);
      });

      EasyLoading.showSuccess('Los usuarios han sido cargados correctamente');
      return list;
      
    } catch (_) {
      EasyLoading.showError('No se pudo cargar la información de los usuarios');
      return [];
    }

  }

  Future<String> login(String username, String pass) async {
    authStatus.value = true;
    try {

      await _initializeDio();
      Response response = await _dio.post('/api/users/signin',
        data: jsonEncode({'username': username, 'password': pass}));
      authStatus.value = false;

      if (response.statusCode == 200) {
        String getrole = response.data['data']['role'];
        String getuserID = response.data['data']['userID'];
        String getcommercialCode = response.data['data']['commercialCode'];
        String getCi = response.data['data']['info']['ci'];
        String getfullName = response.data['data']['info']['full_name'];
        String getPhone = response.data['data']['info']['phone'];
        String getAddress = response.data['data']['info']['address'];
        String gettoken = response.data['data']['token'];

        final LoginData loginData = LoginData()
          ..role = getrole
          ..userID = getuserID
          ..ci = getCi
          ..fullName = getfullName
          ..phone = getPhone
          ..address = getAddress
          ..commercialCode = getcommercialCode
          ..token = gettoken;

        LoginDataService().saveData(loginData);

        return getrole;
      }

      showToast(response.data['api_message']);

      return '';
    } on DioException catch (e) {
      if (e.response != null) {
      } else {
      }
      return 'false';
    }
  }

  Future<bool> changeEnable(String id, bool enable) async {
    try {

      await _initializeDio();
      EasyLoading.show(status: 'Cambiando el acceso...');
      Response response = await _dio.put('/api/users/changeEnable/$id',
        data: jsonEncode({ 'enable': enable }),
        options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El cambio a sido aplicado correctamente');
        return true;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return false;
      }

      EasyLoading.showError('No se pudo aplicar el cambio al usuario seleccionado');
      return false;
    } catch (e) {
      EasyLoading.showError('No se pudo aplicar el cambio al usuario seleccionado');
      return false;
    }
  }

  Future<void> saveUser(String fullname, String ci, String address, String phoneNumber) async {
    try {

      await _initializeDio();
      EasyLoading.show(status: 'Creando usuario...');
      Response response = await _dio.post('/api/users', 
        data: jsonEncode({
          'fullname': fullname, 
          'ci': ci,
          'address': address,
          'phoneNumber': phoneNumber
        }));

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El usuario ha sido creado correctamente');
        return;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return;
      }

      EasyLoading.showError('No se pudo crear el usuario con la información proporcionada');
      return;
    } on Exception catch (_) {
      EasyLoading.showError('No se pudo crear el usuario con la información proporcionada');
    }
  }
  
  Future<void> resetPass(String userId) async {
    try {

      await _initializeDio();
      final queryData = { 'userId': userId };

      Response response = await _dio.post('/api/users/resetpass', 
        queryParameters: queryData, 
        options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        showToast(response.data['api_message'], type: true);
        return;
      }

      if( response.statusCode == 401 ) {
        showToast('Por favor, reinicie su sesión actual, su token ha expirado');
        return;
      }

      showToast(response.data['api_message']);

      return;
    } on Exception catch (e) {
      EasyLoading.showError(e.toString());
    }
  }
 
  Future<bool> changePass(String actualPass, String newPass) async {
    try {

      await _initializeDio();
      EasyLoading.show(status: 'Cambiando contraseña...');

      Response response = await _dio.post('/api/users/changePassword', 
        data: jsonEncode({'actualPass': actualPass, 'newPass': newPass}));

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(response.data['api_message']);
        return true;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return false;
      }

      EasyLoading.showError(response.data['api_message']);
      return false;
    } on Exception catch (e) {
      EasyLoading.showError(e.toString());
      return false;
    }
  }

  Future<void> deleteOne(String id) async {
    try {
      
      await _initializeDio();
      EasyLoading.show(status: 'Eliminando usuario...');
      Response response = await _dio.delete('/api/users/$id', 
        options: Options(validateStatus: (status) => true));
        
      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El usuario ha sido eliminado correctamente');
        return;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return;
      }

      EasyLoading.showError('No se pudo eliminar el usuario seleccionado');
      return;
    } catch (e) {
      EasyLoading.showError('No se pudo eliminar el usuario seleccionado');
      return;
    }
  }

}