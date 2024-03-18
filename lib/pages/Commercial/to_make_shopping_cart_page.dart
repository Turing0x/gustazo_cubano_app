import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
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
    ShoppingCartProvider().clearCart();

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

    return Scaffold(
      appBar: showAppBar('Productos en stock', centerTitle: false, actions: [
        OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
                side: const BorderSide(
              color: Colors.transparent,
            )),
            onPressed: () {
              final provider = ref.watch(cartProvider);
              if (provider.items.isEmpty) {
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

class ShowList extends StatefulWidget {
  const ShowList({super.key, required this.products});

  final List<Product> products;

  @override
  State<ShowList> createState() => _ShowListState();
}

class _ShowListState extends State<ShowList> {
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
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 250
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'product_details_page', arguments: [list[index]]),
                child: ProductCard(product: list[index],));
            },
          )
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

}

class ProductCard extends ConsumerStatefulWidget {

  const ProductCard({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  @override
  Widget build(BuildContext context) {

    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 30),
            Center(
              child: SizedBox(
                height: 70,
                child: Image.asset('lib/assets/images/6720387.jpg')),
            ),
            const Spacer(),
            dosisText(widget.product.name, fontWeight: FontWeight.bold),
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  dosisText('\$${widget.product.price}'),
                  addBuyBtn(widget.product)
                ],
              ),
            )
          ],
        ),
      ),
    );
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

  CircleAvatar addBuyBtn(Product product) {
    final rProdList = ref.read(cartProvider);

    return CircleAvatar(
      backgroundColor: Colors.green[100],
      child: IconButton(
        highlightColor: Colors.transparent,
        onPressed: () {
          if (!rProdList.isInCart(product.id)) {
            setState(() {
              rProdList.addToCart(product);
            });
          } else {
            setState(() {
              rProdList.removeFromCartById(product.id);
            });
          }
        },
        icon: (rProdList.isInCart(product.id))
            ? const Icon(Icons.remove_shopping_cart_outlined, color: Colors.red)
            : const Icon(Icons.add_shopping_cart_outlined, color: Colors.green)));
  }
}
