import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';

class ProductControllers {

  late Dio _dio;

  ProductControllers() {
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

  Future<List<Product>> getAllProducts() async{

    try {

      await _initializeDio();
      EasyLoading.show(status: 'Buscando información de los productos...');
      Response response = await _dio.get('/api/products',
        options: Options(validateStatus: (status) => true));

      if( response.statusCode == 500 ) {
        EasyLoading.showError('No se pudo cargar la información');
        return [];
      }

      if( response.data['data'].isEmpty ) {
        EasyLoading.showInfo('No tenemos productos en stock');
        return [];
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return [];
      }

      List<Product> list = [];

      response.data['data'].forEach((value) {
        final productTemp = Product.fromJson(value);
        list.add(productTemp);
      });

      EasyLoading.showSuccess('La información de los productos en stock ha sido cargada');
      return list;
      
    } catch (_) {
      EasyLoading.showError('No se pudo cargar la información');
      return [];
    }

  }

  Future<List<Product>> getDataForDaily(String date) async{

    try {

      await _initializeDio();
      EasyLoading.show(status: 'Buscando información para generar el resumen del día...');
      Response response = await _dio.get('/api/getDaily/$date',
        options: Options(validateStatus: (status) => true));

      if( response.statusCode == 500 ) {
        return [];
      }

      if( response.data['data'].isEmpty ) {
        return [];
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return [];
      }

      List<Product> list = [];

      response.data['data'].forEach((value) {
        final productTemp = Product.fromJson(value);
        list.add(productTemp);
      });

      return list;
      
    } catch (_) {
      EasyLoading.showError('No se pudo cargar la información');
      return [];
    }

  }

  Future<void> saveProducts(Map<String, dynamic> product) async {
    try {

      await _initializeDio();
      EasyLoading.show(status: 'Añadiendo producto al stock...');
      Response response = await _dio.post('/api/products', 
        data: jsonEncode(product), 
        options: Options(validateStatus: (status) => true) );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El producto a sido añadido correctamente');
        return;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return;
      }

      EasyLoading.showError('No se ha podido añadir el producto');
      return;
    } on Exception catch (_) {
      EasyLoading.showError('No se ha podido añadir el producto');
    }
  }

  Future<void> editProducts(Map<String, dynamic> product, String id) async {
    try {

      await _initializeDio();
      EasyLoading.show(status: 'Editando información del producto...');
      Response response = await _dio.put('/api/products/$id', 
        data: jsonEncode(product), 
        options: Options(validateStatus: (status) => true) );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El producto a sido editado correctamente');
        return;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return;
      }

      EasyLoading.showError('No se ha podido editar el producto');
      return;
    } on Exception catch (_) {
      EasyLoading.showError('No se ha podido editar el producto');
    }
  }

  Future<void> deleteOne(String id) async {
    try {

      await _initializeDio();
      EasyLoading.show(status: 'Eliminando producto del stock...');
      Response response = await _dio.delete('/api/products/$id', 
        options: Options(validateStatus: (status) => true));
        
      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El producto a sido eliminado correctamente');
        return;
      }

      if( response.statusCode == 401 ) {
        EasyLoading.showError('Por favor, reinicie su sesión actual, su token ha expirado');
        return;
      }

      EasyLoading.showError('No se ha podido eliminar el producto');
      return;
    } catch (e) {
      EasyLoading.showError('No se ha podido eliminar el producto');
      return;
    }
  }

}