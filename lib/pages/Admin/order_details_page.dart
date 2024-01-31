import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gustazo_cubano_app/config/Pdf/Order/pdf_order.dart';
import 'package:gustazo_cubano_app/config/Pdf/invoices/order_invoice.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:open_file/open_file.dart';

class OrderDetailsPage extends StatefulWidget {
  const OrderDetailsPage({super.key, required this.order});

  final Order order;

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {

  bool show = false;

  @override
  void initState() {
    LoginDataService().getRole().then((value) {
      if(value == 'commercial'){
        setState(() {show = true;});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Order o = widget.order;

    String fecha = '${o.date.day}/${o.date.month}/${o.date.year} - ${o.date.hour}:${o.date.minute}:${o.date.second}';

    return Scaffold(
      appBar: showAppBar('Detalles de la orden', actions: [
        IconButton(
          onPressed: () => makePDF(), 
          icon: const Icon(Icons.picture_as_pdf_outlined))
      ]),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
          
              customGroupBox('Comercial, cliente y montos de la compra', [
                dosisBold('Comercial: ', o.seller.fullName, 20),
                dosisBold('Código de comercial: ', o.seller.commercialCode, 20),
                Visibility(
                  visible: show,
                  child: dosisBold('Ganacias por comisión: \$', o.commission.numFormat, 18)),
                const Divider(
                  color: Colors.black,
                ),
                dosisBold('Nombre Completo: ', o.buyer.fullName, 20),
                dosisBold('Carnet de Identidad: ', o.buyer.ci, 20),
                dosisBold('Gestión Económica: ', o.buyer.economic, 18),
                dosisBold('Dirección Particular: ', o.buyer.address, 18),
                dosisBold('Número de Contacto: ', o.buyer.phoneNumber, 18),
                dosisBold('Método de pago: ', o.typeCoin, 18),
                const Divider(
                  color: Colors.black,
                ),
                dosisBold('Fecha: ', fecha, 18),
                dosisBold('Número de factura: ', '${o.pendingNumber} - ${o.invoiceNumber}', 18),
                dosisBold('Cant de productos: ', o.getCantOfProducts.toString(), 18),
                dosisBold('Monto total: \$', '${o.totalAmount.numFormat} ${o.typeCoin}', 18)
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

  ListView shoppingCartList(List<Product> rProdList) {
    return ListView.builder(
      itemCount: rProdList.length,
      itemBuilder: (context, index) {
        Product product = rProdList[index];
        return ListTile(
          title: dosisText(product.name, fontWeight: FontWeight.bold),
          subtitle: dosisBold('Precio: \$', product.price.numFormat, 18),
          trailing: dosisText('x ${product.cantToBuy} = ${(product.cantToBuy * product.price).numFormat}', fontWeight: FontWeight.bold),
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
  
  Container productInfo(String name, String price, String commission) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dosisText(name, fontWeight: FontWeight.bold),
          dosisText('Precio: \$$price', color: Colors.blue),
          dosisText('Comisión: $commission%', color: Colors.red),
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
            return Image.asset('lib/assets/images/6720387.jpg');
          },
        ),
      ),
    );
  }

  void makePDF() async{
    DateTime date = widget.order.date;
    String fecha = '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}:${date.second}';

    final invoice = OrderInvoice(
      paymentMethod: widget.order.typeCoin,
      payeerName: widget.order.whoPay.fullName,
      payeerAddress: widget.order.whoPay.address,
      payeerPostalCode: widget.order.whoPay.postalCode,
      payeerPhone: widget.order.whoPay.phoneNumber,
      orderNumber: widget.order.invoiceNumber,
      pendingNumber: widget.order.pendingNumber,
      orderDate: fecha,
      pendingDate: fecha,
      productList: widget.order.productList,
      buyerName: widget.order.buyer.fullName,
      buyerAddress: widget.order.buyer.address,
      buyerEconomic: widget.order.buyer.economic,
      buyerCi: widget.order.buyer.ci,
      buyerPhone: widget.order.buyer.phoneNumber,
    );

    Map<String, dynamic> itsDone =
      await GeneratePdfOrder.generate(invoice);

    if(itsDone['done'] == true){
      OpenFile.open(itsDone['path']);
    } else{
      showToast(itsDone['path'], type: true);
      return;
    }

    showToast('Factura exportada exitosamente', type: true);
  }

}