import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/config/utils/local_storage.dart';
import 'package:gustazo_cubano_app/shared/opt_list_tile.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class MainCommercialPage extends StatelessWidget {
  const MainCommercialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Principal', actions: [
        IconButton(
          onPressed: ()async {
        
            final rProdList = ShoppingCartProvider();

            final contex = Navigator.of(context);

            await LocalStorage.roleDelete();
            await LocalStorage.tokenDelete();
            await LocalStorage.userIdDelete();
            await LocalStorage.usernameDelete();
            await LocalStorage.fullNameDelete();

            rProdList.cleanCart();

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
                Icons.pending_actions_outlined,
                'Mis pedidos',
                'Pedidos aun pendientes',
                () => Navigator.pushNamed(context, 'my_pendings_today_page'),
                true),
      
              optListTile(
                Icons.work_outline_outlined,
                'Mis Órdenes',
                'Historial de órdenes pasadas',
                () => Navigator.pushNamed(context, 'my_orders_history_page'),
                true),
            ],
          
          ),
      
        ),
      
      ),
    );
  }
}