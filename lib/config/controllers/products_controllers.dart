import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ProductControllers {

  final _dio = Dio(
    BaseOptions(
      baseUrl: Uri.http(dotenv.env['SERVER_URL']!).toString(),
      headers: { 'Content-Type': 'application/json' }
    )
  );

  Future<List<Product>> getAllProducts() async{

    try {

      Response response = await _dio.get('/api/products',
        options: Options(validateStatus: (status) => true));

      if( response.statusCode == 500 ) return [];

      List<Product> list = [];

      response.data['data'].forEach((value) {
        final productTemp = Product.fromJson(value);
        list.add(productTemp);
      });

      return list;
      
    } catch (_) {
      return [];
    }

  }

  void saveProducts(Map<String, dynamic> product) async {
    try {

      Response response = await _dio.post('/api/products', 
        data: jsonEncode(product), 
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

  void editProducts(Map<String, dynamic> product, String id) async {
    try {

      Response response = await _dio.put('/api/products/$id', 
        data: jsonEncode(product), 
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

  void deleteOne(String id) async {
    try {

      Response response = await _dio.delete('/api/products/$id', 
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