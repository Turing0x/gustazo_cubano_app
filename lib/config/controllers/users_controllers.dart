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

  final _dio = Dio(
    BaseOptions(
      baseUrl: Uri.http(dotenv.env['SERVER_URL']!).toString(),
      headers: { 'Content-Type': 'application/json' },
      validateStatus: (status) => true
    )
  );

  Future<List<User>> getAllCommercials() async{

    try {

      EasyLoading.show(status: 'Procesando información...');

      Response response = await _dio.get('/api/users',
        options: Options(validateStatus: (status) => true));

      if( response.statusCode == 500 ) {
        EasyLoading.showInfo('No se pudo cargar la información de los usuarios');
        return [];
      }

      if( response.data['data'].isEmpty ) {
        EasyLoading.showInfo('Pedidos pendientes obtenidos correctamente');
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

      Response response = await _dio.post('/api/users/signin',
        data: jsonEncode({'username': username, 'password': pass}),
        options: Options(validateStatus: (status) => true));

      authStatus.value = false;

      if (response.statusCode == 200) {
        String getrole = response.data['data']['role'];
        String getuserID = response.data['data']['userID'];
        String getfullName = response.data['data']['fullName'];
        String getreferalCode = response.data['data']['referalCode'];
        String gettoken = response.data['data']['token'];

        final LoginData loginData = LoginData()
          ..role = getrole
          ..userID = getuserID
          ..fullName = getfullName
          ..referalCode = getreferalCode
          ..token = gettoken;

        LoginDataService().saveData(loginData);

        return getrole;
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

      EasyLoading.show(status: 'Cambiando el acceso...');
      Response response = await _dio.put('/api/users/changeEnable/$id',
        data: jsonEncode({ 'enable': enable }),
        options: Options(validateStatus: (status) => true));

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El cambio a sido aplicado correctamente');
        return true;
      }

      EasyLoading.showError('No se pudo aplicar el cambio al usuario seleccionado');
      return false;
    } catch (e) {
      EasyLoading.showError('No se pudo aplicar el cambio al usuario seleccionado');
      return false;
    }
  }

  void saveUser(String fullName, String username, String password) async {
    try {

      EasyLoading.show(status: 'Creando usuario...');
      Response response = await _dio.post('/api/users', 
        data: jsonEncode({
          'username': username, 
          'password': password,
          'full_name': fullName
        }), 
        options: Options(validateStatus: (status) => true) );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El usuario ha sido creado correctamente');
        return;
      }

      EasyLoading.showError('No se pudo crear el usuario con la información proporcionada');
      return;
    } on Exception catch (_) {
      EasyLoading.showError('No se pudo crear el usuario con la información proporcionada');
    }
  }
  
  void resetPass(String userId) async {
    try {
      final queryData = { 'userId': userId };

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
      
      EasyLoading.show(status: 'Eliminando usuario...');
      Response response = await _dio.delete('/api/users/$id', 
        options: Options(validateStatus: (status) => true));
        
      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El usuario ha sido eliminado correctamente');
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