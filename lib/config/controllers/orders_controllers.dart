import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class OrderControllers {

  final _dio = Dio(
    BaseOptions(
      baseUrl: Uri.http(dotenv.env['SERVER_URL']!).toString(),
      headers: { 'Content-Type': 'application/json' },
      validateStatus: (status) => true
    )
  );

  Future<List<Order>> getAllOrders(bool change, {String date = ''}) async{

    try {

      Response response = await _dio.get('/api/${change ? 'orders/$date' : 'orders/pending/:$date'}');

      if( response.statusCode == 500 ) return [];
      List<Order> list = [];

      response.data['data'].forEach((value) {
        final userTemp = Order.fromJson(value);
        list.add(userTemp);
      });

      return list;
      
    } catch (_) {
      return [];
    }

  }
  
  Future<List<Order>> getOrderById(String orderId) async{

    try {

      Response response = await _dio.get('/api/orders/getById/$orderId');

      if( response.statusCode == 500 ) return [];

      Order order = Order.fromJson(response.data['data']);

      return [order];
      
    } catch (_) {
      return [];
    }

  }
  
  Future<List<Order>> getMyPendingsToday(String referalCode, String date) async{

    try {

      Response response = await _dio.get('/api/orders/getByComm/$referalCode/$date');

      if( response.statusCode == 500 ) return [];

      List<Order> list = [];

      response.data['data'].forEach((value) {
        final userTemp = Order.fromJson(value);
        list.add(userTemp);
      });

      return list;
      
    } catch (_) {
      return [];
    }

  }
  
  Future<List<Order>> getMyOrders(String referalCode, String date) async{

    try {

      Response response = await _dio.get('/api/orders/getByCommOrder/$referalCode/$date');

      if( response.statusCode == 500 ) return [];

      List<Order> list = [];

      response.data['data'].forEach((value) {
        final userTemp = Order.fromJson(value);
        list.add(userTemp);
      });

      return list;
      
    } catch (_) {
      return [];
    }

  }

  void saveOrder(Map<String, dynamic> order) async {
    try {

      Response response = await _dio.post('/api/orders', 
        data: jsonEncode(order) );

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
  
  void editOrder(String orderId, Map<String, dynamic> order) async {
    try {

      Response response = await _dio.put('/api/orders/$orderId', 
        data: jsonEncode(order) );

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
  
  Future<bool> marckAsDoneOrder(String orderId, String invoiceNumber) async {
    try {

      Response response = await _dio.put('/api/orders/$orderId/$invoiceNumber');

      if (response.statusCode == 200) {
        showToast(response.data['api_message'], type: true);
        return true;
      }

      showToast(response.data['api_message']);
      return false;

    } on Exception catch (e) {
      showToast(e.toString());
      return false;
    }
  }

  void deleteOne(String orderId) async {
    try {

      Response response = await _dio.delete('/api/orders/$orderId');
        
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