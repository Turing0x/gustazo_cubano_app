import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class PendingDetailsPage extends StatefulWidget {
  const PendingDetailsPage({super.key, required this.order});

  final Order order;

  @override
  State<PendingDetailsPage> createState() => _PendingDetailsPageState();
}

class _PendingDetailsPageState extends State<PendingDetailsPage> {

  @override
  Widget build(BuildContext context) {

    Order o = widget.order;

    String fecha = '${o.date.day}/${o.date.month}/${o.date.year} - ${o.date.hour}:${o.date.minute}:${o.date.second}';

    return Scaffold(
      appBar: showAppBar('Detalles del pedido', actions: [
        popupMenuButton(widget.order)
      ]),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          
              customGroupBox('Comercial y montos de la compra', [
                dosisBold('Comercial: ', o.seller.fullName, 20),
                dosisBold('Código de referidos: ', o.seller.referalCode, 20),
                dosisBold('Ganacias por comisión: \$', o.commision.toString(), 18),
                const Divider(
                  color: Colors.black,
                ),
                dosisBold('Fecha: ', fecha, 18),
                dosisBold('Cant de productos: ', o.getCantOfProducts.toString(), 18),
                dosisBold('Monto total: \$', o.totalAmount.toString(), 18)
              ]),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: shoppingCartList(o.productList))
          
            ],
          ),
        ),
      ),
    );

  }

  ListView shoppingCartList(List<ProductList> rProdList) {
    return ListView.builder(
      itemCount: rProdList.length,
      itemBuilder: (context, index) {

        ProductList product = rProdList[index];
        return ListTile(
            title: dosisText(product.name, fontWeight: FontWeight.bold),
            subtitle: dosisBold('Precio: \$', product.price.toString(), 18),
            trailing: dosisText(product.cantToBuy.toString(), fontWeight: FontWeight.bold),
          );

      }
    
    );
  }

  Center emptyCart(Size size) {
    return Center(
      child: Column(
        children: [
          Container(
            height: size.height * 0.3,
            margin: EdgeInsets.only(
                left: size.width * .06,
                right: size.width * .06,
                top: size.width * .15,
                bottom: 20),
            child: SvgPicture.asset('lib/assets/images/empty_cart.svg'),
          ),

          dosisText(
            'Acaba de vaciar su carrito. Por favor, regrese al listado de productos', 
            size: 18, maxLines: 3, textAlign: TextAlign.center),
          
        ],
      ));
  }
  
  Container productInfo(String name, String price, String commision) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dosisText(name, fontWeight: FontWeight.bold),
          dosisText('Precio: \$$price', color: Colors.blue),
          dosisText('Comisión: $commision%', color: Colors.red),
        ],
      )
    );
  }

  ClipRRect productPhoto(String photo) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.fromSize(
        size: const Size.fromRadius(48),
        child: Image.network(photo, fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },errorBuilder: (context, error, stackTrace) {
            return Image.asset('lib/assets/images/no_image.jpg');
          },
        ),
      ),
    );
  }

  PopupMenuButton popupMenuButton( Order order ) {
    return PopupMenuButton(

      icon: const Icon(Icons.more_vert, color: Colors.white,),
      onSelected: (value) {
        
        Map<String, void Function()> methods = {
          
          'mark_as_ready': () => Navigator.pushNamed(context, 'confirm_pending_page',
            arguments: [order.id]),
          
          // 'cancel_order': () => ,
          
        };

        methods[value]!.call();

      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'mark_as_ready',
          child: ListTile(
            title: dosisText('Marcar como entregado', size: 18),
            leading: const Icon(Icons.done_outline_rounded, color: Colors.green, size: 19),
          )
        ),
        PopupMenuItem(
          value: 'cancel_order',
          child: ListTile(
            title: dosisText('Cancelar pedido', size: 18),
            leading: const Icon(Icons.cancel_outlined, color: Colors.red, size: 19),
          )
        )
      ],
    );
  }


}