import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gustazo_cubano_app/config/Pdf/Order/pdf_pending.dart';
import 'package:gustazo_cubano_app/config/Pdf/invoces/pending_invoce.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:open_file/open_file.dart';

class PendingDetailsPage extends StatefulWidget {
  const PendingDetailsPage({super.key, required this.order});

  final Order order;

  @override
  State<PendingDetailsPage> createState() => _PendingDetailsPageState();
}

class _PendingDetailsPageState extends State<PendingDetailsPage> {

  bool visible = false;
  @override
  void initState() {
    LoginDataService().getRole().then((value) {
      if(value == 'admin'){
        setState(() {
          visible = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: showAppBar('Detalles del pedido', actions: [
        (visible)
          ? popupMenuButton()
          : popupMenuButton2()
      ]),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: pageColumn()
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
            'Acaba de vaciar su carritorder!. Por favor, regrese al listado de productos', 
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

  Column pageColumn(){

    final o = widget.order;

    String fecha = '${o.date.day}/${o.date.month}/${o.date.year} - ${o.date.hour}:${o.date.minute}:${o.date.second}';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
    
        customGroupBox('Comercial y montos de la compra', [
          dosisBold('Comercial: ', o.seller.fullName, 20),
          dosisBold('Código de comercial: ', o.seller.commercialCode, 20),
          dosisBold('Ganacias por comisión: \$', o.commission.toString(), 18),
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
    );
  }

  PopupMenuButton popupMenuButton() {

    final orderCrt = OrderControllers();
    return PopupMenuButton(

      icon: const Icon(Icons.more_vert, color: Colors.white,),
      onSelected: (value) {
        
        Map<String, void Function()> methods = {
          
          'mark_as_ready': () => Navigator.pushNamed(context, 'confirm_pending_page',
            arguments: [widget.order.id]),
          
          'edit_pending': () => Navigator.pushNamed(context, 'edit_pending_page',
            arguments: [widget.order]),
          
          'cancel_order': () => {
            orderCrt.deleteOne(widget.order.id),
            Navigator.pushReplacementNamed(context, 'pendings_control_page')
          }

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
          value: 'edit_pending',
          child: ListTile(
            title: dosisText('Editar este pedido', size: 18),
            leading: const Icon(Icons.edit_document, color: Colors.blue, size: 19),
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
  
  PopupMenuButton popupMenuButton2() {

    final orderCrt = OrderControllers();
    return PopupMenuButton(

      icon: const Icon(Icons.more_vert, color: Colors.white,),
      onSelected: (value) {
        
        Map<String, void Function()> methods = {
          
          'make_pdf': () => makePDF(),

          'edit_pending': () => Navigator.pushNamed(context, 'edit_pending_page',
            arguments: [widget.order]),
          
          'cancel_order': () => actionsSnackBar(context, 'Confirmar eliminación',
            'Eliminar', (){
              orderCrt.deleteOne(widget.order.id);
              Navigator.popAndPushNamed(context, 'my_pendings_today_page');
          })

        };

        methods[value]!.call();

      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'make_pdf',
          child: ListTile(
            title: dosisText('Hacer PDF', size: 18),
            leading: const Icon(Icons.picture_as_pdf_outlined, color: Colors.blue, size: 19),
          )
        ),
        PopupMenuItem(
          value: 'edit_pending',
          child: ListTile(
            title: dosisText('Editar este pedido', size: 18),
            leading: const Icon(Icons.edit_document, color: Colors.blue, size: 19),
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

  void makePDF() async{
    DateTime date = widget.order.date;
    String fecha = '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute}:${date.second}';

    final invoice = PendingInvoce(
      orderNumber: widget.order.invoiceNumber,
      pendingNumber: widget.order.pendingNumber,
      orderDate: fecha,
      productList: widget.order.productList,
      buyerName: widget.order.buyer.fullName,
      buyerAddress: widget.order.buyer.address,
      buyerCi: widget.order.buyer.ci,
      buyerPhone: widget.order.buyer.phoneNumber,
    );

    Map<String, dynamic> itsDone =
      await GeneratePdfPending.generate(invoice);

    if(itsDone['done'] == true){
      OpenFile.open(itsDone['path']);
    }

    showToast('Factura exportada exitosamente', type: true);
  }

}