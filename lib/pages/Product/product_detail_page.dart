import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/helpers/check_url.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/product_photo.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: showAppBar('Detalles'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              Center(
                child: Container(
                  height: size.height * 0.3,
                  width: size.height * 0.3,
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: (widget.product.photo.isNotEmpty && 
                    checkUrl(widget.product.photo)) 
                    ? productPhoto(widget.product.photo)
                    : Image.asset('lib/assets/images/6720387.jpg'))
                ),
          
              dosisText(widget.product.name, fontWeight: FontWeight.bold,
                size: 30),

              dosisText('\$${widget.product.price.numFormat} CUP', fontWeight: FontWeight.bold,
                size: 20),

              dosisBold('Proveedor: ', widget.product.provider.toString(), 20),

              dosisBold('Stock: ', widget.product.inStock.toString(), 20),

              const SizedBox(height: 20),
              dosisText(widget.product.description, fontWeight: FontWeight.bold,
                size: 20),

              const SizedBox(height: 20),
              dosisBold('Comisión de ganancia: ', '${widget.product.commission.numFormat} CUP', 20),

              const SizedBox(height: 10),
              dosisText('Venta al por mayor', fontWeight: FontWeight.bold, size: 20),
              const Divider(color: Colors.black),

              dosisBold('Cantidad a superar: ', widget.product.moreThan.toString(), 20),
              dosisBold('Precio de venta: ', '${widget.product.discount.numFormat} CUP', 20),
              dosisBold('Comisión: ', '${widget.product.commissionDiscount.numFormat} CUP', 20),
          
            ],
          ),
        ),
      ),
    );
  }

}