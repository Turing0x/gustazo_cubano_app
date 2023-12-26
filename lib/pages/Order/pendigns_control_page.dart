import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class PendignsControlPage extends ConsumerStatefulWidget {
  const PendignsControlPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PendignsControlPageState();
}

class _PendignsControlPageState extends ConsumerState<PendignsControlPage> {

  @override
  Widget build(BuildContext context) {

    final janddate = ref.watch(janddateR);

    return Scaffold(
      appBar: showAppBar('Control de pedidos'),
      body: FutureBuilder(
        future: OrderControllers().getAllOrders(false, date: janddate.currentDate), 
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context, 'No tenemos pedidos en este momento. Vuelva en otro momento');
          }

          final list = snapshot.data;
          
          return ListView.builder(
      
            itemCount: list!.length,
            itemBuilder: (context, index) {

              Order order = list[index];
              
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 1,
                    blurRadius: 1
                  )]
                ),
                child: ListTile(
                  title: dosisText(order.seller.fullName, fontWeight: FontWeight.bold),
                  subtitle: dosisBold('Monto: \$', 
                    order.totalAmount.toStringAsFixed(2), 18),
                  trailing: CircleAvatar(
                    child: dosisText(order.productList.length.toString(),
                    fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.pushNamed(context, 'pending_details_page', arguments: [
                    order
                  ]),
                ),
              );
            },
          
          );

        },
      )

    );

  }

}