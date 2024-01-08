import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';

Future<String> initialRoute() async {
  final role = await LoginDataService().getRole();

  if (role != '' ) {
    return _initialRouteByRole(role!);
  }

  return 'auth_page';
}

bool excede100Minutos(DateTime fecha) {
  DateTime horaActual = DateTime.now();
  Duration diferencia = horaActual.difference(fecha);

  if (diferencia.inMinutes > 95) {
    return true;
  }

  return false;
}

String _initialRouteByRole(String role) {
  Map<String, String> mainPages = {
    'admin': 'main_admin_page',
    'commercial': 'main_commercial_page',
  };

  return mainPages[role]!;
}