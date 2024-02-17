import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/helpers/check_url.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ToMakeShoppingCartPage extends ConsumerStatefulWidget {
  const ToMakeShoppingCartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ToMakeShoppingCartPageState();
}

class _ToMakeShoppingCartPageState extends ConsumerState<ToMakeShoppingCartPage> {
  List<Product> products = [];

  @override
  void initState() {
    ShoppingCartProvider().cleanCart();

    ProductControllers().getAllProducts().then((value) {
      if (value.isNotEmpty) {
        for (var element in value) {
          setState(() {
            products.add(element);
          });
        }
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rProdList = ShoppingCartProvider();

    return Scaffold(
      appBar: showAppBar('Productos en stock', centerTitle: false, actions: [
        OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(
              color: Colors.transparent,
            )),
            onPressed: () {
              if (rProdList.isEmpty()) {
                simpleMessageSnackBar(context, texto: 'EL carrito de la compra esta vacío', typeMessage: false);
                return;
              }

              Navigator.pushNamed(context, 'shopping_cart_page');
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
            label: dosisText(
              'Carrito',
              color: Colors.white,
            ))
      ]),
      body: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: (products.isEmpty)
              ? noData(context, 'Parece que no tenemos productos en stock en este momento')
              : ShowList(products: products)),
    );
  }
}

class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key, required this.products});

  final List<Product> products;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {
  TextEditingController controller = TextEditingController();
  late List<Product> list;

  @override
  void initState() {
    list = widget.products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          height: 60,
          child: TextField(
            controller: controller,
            onChanged: searchProduct,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Título del producto',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.blue))),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'product_details_page', arguments: [list[index]]),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)]),
                    child: Column(
                      children: [
                        bodyProd(index),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                list[index].description,
                                style:
                                    const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 18, fontFamily: 'Dosis'),
                              ),
                            ),
                            addBuyBtn(list[index]),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    ));
  }

  void searchProduct(String query) {
    List<Product> suggestions = list.where((element) {
      final productTitle = element.name.toLowerCase();
      final input = query.toLowerCase();

      return productTitle.contains(input);
    }).toList();

    if (suggestions.isEmpty || query == '') {
      setState(() {
        suggestions = widget.products;
      });
    }

    setState(() => list = suggestions);
  }

  Row bodyProd(int index) {
    return Row(
      children: [
        SizedBox(
            height: 70,
            child: (list[index].photo.isNotEmpty && checkUrl(list[index].photo))
                ? productPhoto(list[index].photo)
                : Image.asset('lib/assets/images/6720387.jpg')),
        productInfo(list[index].name, list[index].price.toString().intPart, list[index].coin,
            list[index].inStock.toStringAsFixed(0)),
      ],
    );
  }

  Container productInfo(String name, String price, String coin, String stock) {
    return Container(
        margin: const EdgeInsets.only(left: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: Text(name,
                  style: const TextStyle(
                      fontFamily: 'Dosis', fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
            ),
            dosisText('\$$price $coin', color: Colors.blue),
            dosisText('Stock: $stock', color: Colors.green),
          ],
        ));
  }

  ClipRRect productPhoto(String photo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.fromSize(
        size: const Size.fromRadius(48),
        child: Image.network(
          photo,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('lib/assets/images/6720387.jpg');
          },
        ),
      ),
    );
  }

  Container addBuyBtn(Product product) {
    final productList = StateNotifierProvider<ShoppingCartProvider, Product>((ref) => ShoppingCartProvider());
    final rProdList = ref.read(productList.notifier);

    return Container(
        width: 80,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.green[100],
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), bottomRight: Radius.circular(10)),
            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)]),
        child: IconButton(
            highlightColor: Colors.transparent,
            onPressed: () {
              if (!rProdList.isInCart(product.id)) {
                setState(() {
                  rProdList.addProductToList(product);
                });
              } else {
                setState(() {
                  rProdList.removeProductFromList(product.id);
                });
              }
            },
            icon: (rProdList.isInCart(product.id))
                ? const Icon(Icons.remove_shopping_cart_outlined, color: Colors.red)
                : const Icon(Icons.add_shopping_cart_outlined, color: Colors.green)));
  }
}
