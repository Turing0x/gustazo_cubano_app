import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/coins_controllers.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/shared/opt_list_tile.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class MainStoragePage extends ConsumerStatefulWidget {
  const MainStoragePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainStoragePageState();
}

class _MainStoragePageState extends ConsumerState<MainStoragePage> {

  @override
  void initState() {
    final prices = ref.read(coinPrices.notifier);
    CoinControllers().getAllCoins().then((value) {
      if(value.isNotEmpty){
        setState(() {
          prices.setMlc(value[0].mlc);
          prices.setUsd(value[0].usd);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
  
      appBar: showAppBar('Zona del Almacén', actions: [
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
                Icons.shopping_cart_outlined,
                'Hacer carrito',
                'LLenar el carrito de la compra',
                () => Navigator.pushNamed(context, 'to_make_shopping_cart_page'),
                true),
          
              optListTile(
                Icons.sell_outlined,
                'Stock',
                'Logística de la mercancía',
                () => Navigator.pushNamed(context, 'stock_control_page'),
                true),

              optListTile(
                Icons.pending_actions_outlined,
                'Pedidos',
                'Ordenes aún pendientes',
                () => Navigator.pushNamed(context, 'pending_control_page'),
                true),

              optListTile(
                Icons.work_history_outlined,
                'Ordenes',
                'Historial de órdenes pasadas',
                () => Navigator.pushNamed(context, 'orders_history_page'),
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