import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/shared/opt_list_tile.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class SettingAdminPage extends StatelessWidget {
  const SettingAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Configuraciones'),
      body: Column(
        children: [
          optListTile(Icons.groups_2_outlined, 'Equipo de trabajo', 'Empleados del negocio',
              () => Navigator.pushNamed(context, 'commercials_control_page'), true),
          optListTile(Icons.monitor_heart_outlined, 'Cálculos de monedas', 'Cambio con respeto al CUP',
              () => Navigator.pushNamed(context, 'change_coins_page'), true),
          optListTile(Icons.document_scanner_outlined, 'Mis PDFs', 'PDFs Generados de órdenes y pedidos',
              () => Navigator.pushNamed(context, 'internal_storage_page'), true),
          optListTile(Icons.change_circle_outlined, 'Cambiar contraseña', 'Cambie su contraseña actual',
              () => Navigator.pushNamed(context, 'change_password'), true),
          OutlinedButton.icon(
              onPressed: () {
                final contex = Navigator.of(context);

                LoginDataService().deleteData();

                contex.pushNamedAndRemoveUntil('auth_page', (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.logout),
              label: dosisText('Cerrar Sesión'))
        ],
      ),
    );
  }
}
