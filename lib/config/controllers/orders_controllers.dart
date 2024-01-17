import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
      EasyLoading.show(status: 'Obteniendo todos los pedidos...');
      Response response = await _dio.get('/api/${change ? 'orders/$date' : 'orders/pending/:$date'}');

      if( response.statusCode == 500 ) {
        EasyLoading.showError('No se pudo obtener los pedidos');
        return [];
      }

      if( response.data['data'].isEmpty ) {
        EasyLoading.showInfo('Pedidos pendientes obtenidos correctamente');
        return [];
      }

      List<Order> list = [];
      response.data['data'].forEach((value) {
        final userTemp = Order.fromJson(value);
        list.add(userTemp);
      });
      EasyLoading.showSuccess('Pedidos obtenidos correctamente');
      return list;
      
    } catch (_) {
      EasyLoading.showError('No se pudo obtener los pedidos');
      return [];
    }
  }
  
  Future<List<Order>> getOrderById(String orderId) async{
    try {
      EasyLoading.show(status: 'Obteniendo órden por ID...');
      Response response = await _dio.get('/api/orders/getById/$orderId');

      if( response.statusCode == 500 ) {
        EasyLoading.showError('No se pudo obtener la órden');
        return [];
      }

      Order order = Order.fromJson(response.data['data']);
      EasyLoading.showSuccess('Pedido obtenido correctamente');
      return [order];
      
    } catch (_) {
      EasyLoading.showError('No se pudo obtener la órden');
      return [];
    }
  }
  
  Future<List<Order>> getMyPendingsToday(String referalCode, String date) async{
    try {

      EasyLoading.show(status: 'Obteniendo mis pedidos pendientes de hoy...');
      Response response = await _dio.get('/api/orders/getByComm/$referalCode/$date');

      if( response.statusCode == 500 ) {
        EasyLoading.showError('No se pudo obtener los pedidos pendientes');
        return [];
      }

      if( response.data['data'].isEmpty ) {
        EasyLoading.showInfo('No hay pedidos para hoy');
        return [];
      }

      List<Order> list = [];
      response.data['data'].forEach((value) {
        final userTemp = Order.fromJson(value);
        list.add(userTemp);
      });

      EasyLoading.showSuccess('Pedidos pendientes obtenidos correctamente');
      return list;
      
    } catch (e) {
      EasyLoading.showError('No se pudo obtener los pedidos pendientes');
      return [];
    }
  }
  
  Future<List<Order>> getMyOrders(String referalCode, String date) async{
    try {
      EasyLoading.show(status: 'Obteniendo mis órdenes...');
      Response response = await _dio.get('/api/orders/getByCommOrder/$referalCode/$date');

      if( response.statusCode == 500 ) {
        EasyLoading.showError('No se pudo obtener las órdenes');
        return [];
      }

      if( response.data['data'].isEmpty ) {
        EasyLoading.showInfo('No hay órdenes para hoy');
        return [];
      }

      List<Order> list = [];
      response.data['data'].forEach((value) {
        final userTemp = Order.fromJson(value);
        list.add(userTemp);
      });
      EasyLoading.showSuccess('Órdenes obtenidas correctamente');
      return list;
      
    } catch (_) {
      EasyLoading.showError('No se pudo obtener las órdenes');
      return [];
    }
  }

  void saveOrder(Map<String, dynamic> order) async {
    try {
      EasyLoading.show(status: 'Guardando pedido...');
      Response response = await _dio.post('/api/orders', 
        data: jsonEncode(order) );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Pedido guardado correctamente');
        return;
      }

      EasyLoading.showError('No se pudo guardar el pedido');
      return;
    } on Exception catch (_) {
      EasyLoading.showError('No se pudo guardar el pedido');
    }
  }
  
  void editOrder(String orderId, Map<String, dynamic> order) async {
    try {
      EasyLoading.show(status: 'Editando pedido...');
      Response response = await _dio.put('/api/orders/$orderId', 
        data: jsonEncode(order) );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Pedido editado correctamente');
        return;
      }

      EasyLoading.showError('No se pudo editar el pedido');
      return;
    } on Exception catch (_) {
      EasyLoading.showError('No se pudo editar el pedido');
    }
  }
  
  Future<bool> marckAsDoneOrder(String orderId, String invoiceNumber) async {
    try {
      EasyLoading.show(status: 'Marcando pedido como hecho...');
      Response response = await _dio.put('/api/orders/$orderId/$invoiceNumber');

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Pedido marcado como hecho correctamente');
        return true;
      }

      EasyLoading.showError('No se pudo marcar el pedido como hecho');
      return false;

    } on Exception catch (_) {
      EasyLoading.showError('No se pudo marcar el pedido como hecho');
      return false;
    }
  }

  void deleteOne(String orderId) async {
    try {

      EasyLoading.show(status: 'Eliminando el pedido...');
      Response response = await _dio.delete('/api/orders/$orderId');
        
      if (response.statusCode == 200) {
        EasyLoading.showSuccess('El pedido a sido eliminado correctamente');
        showToast(response.data['api_message'], type: true);
        return;
      }

      showToast(response.data['api_message']);
      EasyLoading.showError('No se ha podido eliminar el pedido');
      return;
    } catch (_) {
      EasyLoading.showError('No se ha podido eliminar el pedido');
      return;
    }
  }

}