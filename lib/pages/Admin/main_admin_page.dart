import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/shared/opt_list_tile.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class MainAdminPage extends StatefulWidget {
  const MainAdminPage({super.key});

  @override
  State<MainAdminPage> createState() => _MainAdminPageState();
}

class _MainAdminPageState extends State<MainAdminPage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
  
      appBar: showAppBar('Zona Administrativa', actions: [
        IconButton(
          onPressed: ()async {
            final contex = Navigator.of(context);

            LoginDataService().deleteData();

            contex.pushNamedAndRemoveUntil(
                'auth_page', (Route<dynamic> route) => false);
          },
          icon: const Icon(Icons.logout))
      ]),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
          
            children: [
          
              optListTile(
                Icons.sell_outlined,
                'Stock',
                'Logística de la mercancía',
                () => Navigator.pushNamed(context, 'stock_control_page'),
                true),

              optListTile(
                Icons.groups_2_outlined,
                'Equipo de trabajo',
                'Empleados del negocio',
                () => Navigator.pushNamed(context, 'commercials_control_page'),
                true),
          
              optListTile(
                Icons.pending_actions_outlined,
                'Pedidos',
                'Ordenes aún pendientes',
                () => Navigator.pushNamed(context, 'pendings_control_page'),
                true),

              optListTile(
                Icons.work_history_outlined,
                'Ordenes',
                'Historial de órdenes pasadas',
                () => Navigator.pushNamed(context, 'orders_history_page'),
                true),

              optListTile(
                Icons.monitor_heart_outlined,
                'Cálculos de monedas',
                'Cambio con respeto al CUP',
                () => Navigator.pushNamed(context, 'change_coins_page'),
                true),

              optListTile(
                Icons.document_scanner_outlined,
                'Mis PDFs',
                'PDFs Generados de órdenes y pedidos',
                () => Navigator.pushNamed(context, 'internal_storage_page'),
                true),

              optListTile(
                Icons.change_circle_outlined,
                'Cambiar contraseña',
                'Cambie su contraseña actual',
                () => Navigator.pushNamed(context, 'change_password'),
                true),
          
            ],
          
          ),

        ),

      ),
  
    );

  }

}