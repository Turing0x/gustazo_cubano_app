import 'package:gustazo_cubano_app/config/utils/local_storage.dart';

Future<String> initialRoute() async {
  final role = await LocalStorage.getRole();
  final lastTime = await LocalStorage.getTimeSign();

  if (role != null &&
      !excede100Minutos(
          DateTime.parse(lastTime ?? '2020-01-01T00:00:00.000+00:00'))) {
    return _initialRouteByRole(role);
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