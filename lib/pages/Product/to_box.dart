
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/helpers/determinate_amount.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/pages/Product/shopping_cart_page.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ToMakeUnityDesign extends ConsumerStatefulWidget {
  const ToMakeUnityDesign({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ToMakeUnityDesignState();
}

class _ToMakeUnityDesignState extends ConsumerState<ToMakeUnityDesign> {
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 80, height: 80, child: Image.asset('lib/assets/images/6720387.jpg')),
            const Spacer(),
            addBuyBtn(widget.product.id)
          ],
        ),
        const SizedBox(height: 10),
        productInfo(
          widget.product.name, 
          widget.product.coin, 
          widget.product.price, 
          widget.product.inStock.toStringAsFixed(0),
          widget.product.sellType, 
          widget.product.box, 
        ),
        const Spacer(),
        btnCant(widget.product)
      ],
    );
  }

  Column productInfo(String name, String coin, double price, String stock, String type, int cant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dosisText(name, fontWeight: FontWeight.bold),
        dosisText('Precio: \$${(coin == coinType) 
          ? price 
          : calculatePurchaseAmount(ref, coinType, price)} $coin',
            color: Colors.blue),
        Visibility(
          visible: cant != 0,
          child: dosisText('Caja de $cant unidades', color: Colors.blue)),
        dosisText('Stock: $stock', color: Colors.green)
      ],
    );
  }

  Container addBuyBtn(String productId) {
    final rProdList = ref.watch(cartProvider);

    return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 1)]),
        child: Center(
            child: dosisText(rProdList.cantOfAProduct(productId).toString(),
                color: Colors.blue, fontWeight: FontWeight.bold)));
  }

  Row btnCant(Product product) {

    final rProdList = ref.watch(cartProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          onPressed: () {
            rProdList.decreaseQuantityById(product.id, amount: 10);
          },
          icon: dosisText('-10', fontWeight: FontWeight.bold)),
        IconButton(
          style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          onPressed: () {
            rProdList.decreaseQuantityById(product.id);
          },
          icon: const Icon(Icons.remove, color: Colors.red)),
        IconButton(
          style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          onPressed: () {
            rProdList.increaseQuantityById(product.id);
          },
          icon: const Icon(Icons.add, color: Colors.green)),
        IconButton(
          style: const ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          onPressed: () {
            rProdList.increaseQuantityById(product.id, amount: 10);
          },
          icon: dosisText('+10', fontWeight: FontWeight.bold)),
    ],
  );
}

}
