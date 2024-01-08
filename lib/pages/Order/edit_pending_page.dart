import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/models/order_model.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class EditPendingPage extends ConsumerStatefulWidget {
  const EditPendingPage({super.key, required this.order});

  final Order order;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditPendingPageState();
}

class _EditPendingPageState extends ConsumerState<EditPendingPage> {

  final ScrollController _controller = ScrollController();
  String role = '';
  bool _visible = true;

  @override
  void initState() {

    final rProdList = ShoppingCartProvider();
    for(var order in widget.order.productList){
      setState(() {
        rProdList.addProductToListOnEditing(order);
      });
    }

    LoginDataService().getRole().then((value) {
      setState(() {
        role = value!;
      });
    });

    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.reverse) {
        if (_visible == true) {
          setState(() {
            _visible = false;
          });
        }
      } else if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        if (_visible == false) {
          setState(() {
            _visible = true;
          });
        }
      }
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {

    final rProdList = ShoppingCartProvider();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: showAppBar('Carrito', centerTitle: false, actions: [
        IconButton(
          onPressed: () {
            if(rProdList.products.isNotEmpty){
              Navigator.pushNamed(context, 'add_products_on_editing');
            }
          }, 
          icon: const Icon(Icons.add_shopping_cart_outlined, color: Colors.white),
        ),
        OutlinedButton.icon(
          onPressed: () {
            final orderCtrl = OrderControllers();

            List<Product> list = [];
            rProdList.products.forEach((key, value) {
              list.add(value);
            });

            Map<String, dynamic> order = {
              'product_list': list,
            };
            
            orderCtrl.editOrder(widget.order.id, order);

            Navigator.pushReplacementNamed(context, (role != 'admin') 
              ? 'my_pendings_today_page' : 'pendings_control_page', arguments: [
                widget.order.seller.referalCode
              ]);
          }, 
          icon: const Icon(Icons.done, color: Colors.white),
          label: dosisText('Listo', color: Colors.white),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.transparent)
          ),
        ),
      ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            customGroupBox('Información del carrito', [
              dosisBold('Cantidad de productos: ', rProdList.productsCant.toString(), 20),
              dosisBold('Monto de la compra: ', rProdList.totalAmount.toStringAsFixed(2), 20),
              dosisBold('Comisión por la compra: ', rProdList.totalCommisionMoney.toStringAsFixed(2), 20)
            ]),

            ( rProdList.products.isEmpty )
              ? emptyCart(size)
              : Flexible(child: ValueListenableBuilder(
                  valueListenable: reloadShoppingCart,
                  builder: (context, value, child) {
                    return shoppingCartList(rProdList); 
                  }
              
              )

            )

          ],

        )

      ),

    );

  }

  ListView shoppingCartList(ShoppingCartProvider rProdList) {
    return ListView.builder(
      controller: _controller,
      itemCount: rProdList.products.length,
      itemBuilder: (context, index) {

        Product product = rProdList.products.values.elementAt(index);
        return Container(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [BoxShadow(
              color: Colors.black12,
              spreadRadius: 1,
              blurRadius: 1
            )]
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
              
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.asset('lib/assets/images/6720387.jpg')),
              
                  productInfo(
                    product.name, 
                    product.price.toString(),
                    product.inStock.toStringAsFixed(0)),
              
                  const Spacer(),
              
                  addBuyBtn(product.id)
              
                ],
              ),const SizedBox(height: 5),
        
              Flexible(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        side: const BorderSide(color: Colors.transparent)
                      ),
                      onPressed: (){
                        setState(() {
                          rProdList.removeProductFromList(product.id);
                        });
                      }, 
                      icon: const Icon(Icons.delete_forever_outlined, color: Colors.black, size: 18,), 
                      label: dosisText('Quitar', size: 18)
                    ),
                    const SizedBox(width: 50),

                    IconButton(
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                      ),
                      onPressed: (){
                        setState(() {
                          rProdList.decreaseTenCantToBuyOfAProduct(product.id);
                        });
                      }, 
                      icon: dosisText('-10', fontWeight: FontWeight.bold)
                    ),
                    IconButton(
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                      ),
                      onPressed: (){
                        setState(() {
                          rProdList.decreaseCantToBuyOfAProduct(product.id);
                        });
                      }, 
                      icon: const Icon(Icons.remove, color: Colors.red)
                    ),
                    IconButton(
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                      ),
                      onPressed: (){
                        setState(() {
                          rProdList.addProductToList(product);
                        });
                      }, 
                      icon: const Icon(Icons.add, color: Colors.green)
                    ),
                    IconButton(
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap
                      ),
                      onPressed: (){
                        setState(() {
                          rProdList.addTenCantToBuyOfAProduct(product.id);
                        });
                      }, 
                      icon: dosisText('+10', fontWeight: FontWeight.bold)
                    ),
                  ],
                ),
              )

            ],

          ),

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
  
  Container productInfo(String name, String price, String stock) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dosisText(name, fontWeight: FontWeight.bold),
          dosisText('Precio: \$$price', color: Colors.blue),
          dosisText('Stock: $stock', color: Colors.green)
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

  Container addBuyBtn(String productId) {

    final productList = StateNotifierProvider<ShoppingCartProvider, Product>(
      (ref) => ShoppingCartProvider());
    final rProdList = ref.read(productList.notifier);

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 1
        )]
      ),
      child: Center(
        child: dosisText(
          rProdList.cantOfAProduct(productId).toString(),
          color: Colors.blue, fontWeight: FontWeight.bold))
    );
  }

}