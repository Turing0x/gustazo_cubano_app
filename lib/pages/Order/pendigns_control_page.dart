import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:intl/intl.dart';

class PendingControlPage extends ConsumerStatefulWidget {
  const PendingControlPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PendingControlPageState();
}

class _PendingControlPageState extends ConsumerState<PendingControlPage> {

  TextEditingController controller = TextEditingController();
  List<Order> list = [];
  List<Order> list2 = [];

  String filterType = 'buyer';
  String hintText = 'Nombre del comprador';

  @override
  void initState() {

    String date = DateFormat.MMMd('en').format(DateTime.now());

    OrderControllers().getAllOrders(
      false, date: date).then((value) {
        setState(() {
          list = value;
          list2 = value;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: showAppBar('Control de pedidos'),
      body: Column(
        children: [

          Container(
            margin: const EdgeInsets.all(10),
            height: 60,
            child: TextField(
              controller: controller,
              onChanged: searchOrders,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: popupMenuButton(),
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue)
                )
              ),
            ),
          ),

          (list.isEmpty)
            ? noData(context, 
              'No tenemos pedidos en este momento. Vuelva en otro momento')
            : showList(),
        ],
      )

    );

  }

  Expanded showList() {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: reloadPending,
        builder: (context, value, child) => ListView.builder(
          itemCount: list.length,
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
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    dosisText('Comprador: ${order.buyer.fullName}', fontWeight: FontWeight.bold),
                    dosisText('Comercial: ${order.seller.fullName.split(' ')[0]}'),
                  ],
                ),
                subtitle: dosisBold('Pedido: ', 
                  order.pendingNumber, 18),
                trailing: CircleAvatar(
                  child: dosisText(order.productList.length.toString(),
                  fontWeight: FontWeight.bold)),
                onTap: () => Navigator.pushReplacementNamed(context, 'pending_details_page', arguments: [
                  order
                ]),
              ),
            );
          },
        
        )
      ),
    );
  }

  void searchOrders(String query){
    List<Order> suggestions = list.where((element) {

      final title = (filterType == 'num')
        ? element.pendingNumber.toLowerCase()
        : ( filterType == 'seller' )
          ? element.seller.fullName.toLowerCase()
          : element.buyer.fullName.toLowerCase();

      final input = query.toLowerCase();

      return title.contains(input);
    }).toList();

    if(suggestions.isEmpty || query == ''){
      setState(() {
        suggestions = list2;
      });
    }

    setState(() => list = suggestions);
  }

  PopupMenuButton popupMenuButton() {
    return PopupMenuButton(
      icon: const Icon(Icons.filter_alt_outlined),
      onSelected: (value) {

        Map<String, void Function()> methods = {

          'num': (){
            setState(() {
              filterType = 'num';
              hintText = 'Número de pedido';
            });
          },
          'seller': (){
            setState(() {
              filterType = 'seller';
              hintText = 'Nombre del vendedor';
            });
          },
          'buyer': (){
            setState(() {
              filterType = 'buyer';
              hintText = 'Nombre del comprador';
            });
          },

        };

        methods[value]!.call();
      
      },
      itemBuilder: (BuildContext context) {
        const icon2 = Icon(Icons.check_circle_outline_rounded, color: Colors.green,);
        return [
        PopupMenuItem(
          value: 'num',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dosisText('Número de pedido'),
              Visibility(
                visible: filterType == 'num',
                child: icon2
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 'seller',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dosisText('Nombre del vendedor'),
              Visibility(
                visible: filterType == 'seller',
                child: icon2
              )
            ],
          ),
        ),
        PopupMenuItem(
          value: 'buyer',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              dosisText('Nombre del comprador'),
              Visibility(
                visible: filterType == 'buyer',
                child: icon2
              )
            ],
          ),
        ),
      ];
      },
    );
  }

}