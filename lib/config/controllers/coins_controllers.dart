import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/models/coin_model.dart';

class CoinControllers {

  late Dio _dio;

  CoinControllers() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final token = await LoginDataService().getToken();

    _dio = Dio(
      BaseOptions(
        baseUrl: Uri.https(dotenv.env['SERVER_URL']!).toString(),
        headers: {
          'Content-Type': 'application/json',
          'access-token': token,
        },
        validateStatus: (status) => true,
      ),
    );
  }

  Future<List<Coin>> getAllCoins() async{

    try {

      await _initializeDio();
      Response response = await _dio.get('/api/coins',
        options: Options(validateStatus: (status) => true));

      if( response.statusCode == 500 ) {
        return [];
      }

      if( response.statusCode == 401 ) {
        return [];
      }

      List<Coin> list = [];

      response.data['data'].forEach((value) {
        final coinTemp = Coin.fromJson(value);
        list.add(coinTemp);
      });

      return list;
      
    } catch (_) {
      return [];
    }

  }

  Future<void> saveCoins(Map<String, dynamic> coin) async {
    try {

      await _initializeDio();
      EasyLoading.show(status: 'Guardando información...');
      Response response = await _dio.post('/api/coins', 
        data: jsonEncode(coin), 
        options: Options(validateStatus: (status) => true) );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('La información a sido guardada correctamente');
        return;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return;
      }

      EasyLoading.showError('No se ha podido guardar la información');
      return;
    } on Exception catch (_) {
      EasyLoading.showError('No se ha podido guardar la información');
    }
  }

}