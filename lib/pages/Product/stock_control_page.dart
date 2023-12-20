import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/shared_dismissible.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class StockControlPage extends StatefulWidget {
  const StockControlPage({super.key});

  @override
  State<StockControlPage> createState() => _StockControlPageState();
}

class _StockControlPageState extends State<StockControlPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Control de productos', actions: [
        IconButton(
          onPressed: () => Navigator.pushNamed(context, 'create_product_page'), 
          icon: const Icon(Icons.playlist_add_outlined))
      ]),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const ShowList()
      ),
    );
  }
}


class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {

  @override
  Widget build(BuildContext context) {

    ProductControllers productCtrl = ProductControllers();

    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: reloadProducts,
        builder: (BuildContext context, bool value, Widget? child) {
          return FutureBuilder(
            future: productCtrl.getAllProducts(),
            builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return noData(context, 
                  'Parece que no hay productos en stock. Para añadir uno, pinche el ícono de la esquina superior derecha');
              }
          
              final products = snapshot.data;

              return ListView.builder(
                itemCount: products!.length,
                itemBuilder: (context, index) {
                  return CommonDismissible(
                    canDissmis: true,
                    text: 'Eliminar producto',
                    valueKey: products[index].id,
                    onDismissed: (direction) {
                      ProductControllers().deleteOne(products[index].id);
                      setState(() {
                        snapshot.data!.remove(products[index]);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 1,
                            blurRadius: 2
                          )
                        ]
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.sell_outlined),
                        title: dosisText(products[index].name, fontWeight: FontWeight.bold),
                        subtitle: dosisText('En stock: ${products[index].inStock}'),
                        trailing: const Icon(Icons.arrow_right_rounded),
                        onTap: () => Navigator.pushNamed(context, 'product_detail_page', arguments: [products[index]]),
                      )
                    )
                  );
                });
              },
            );
        }
      ),
    );
  }

  Container photoProduct(String urlImage) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      width: 130,
      height: 140,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 3
        ),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Image.network(urlImage, fit: BoxFit.fill),
    );
  }

}
