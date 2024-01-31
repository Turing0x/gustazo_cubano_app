import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/helpers/determinate_amount.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ShoppingCartPage extends ConsumerStatefulWidget {
  const ShoppingCartPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends ConsumerState<ShoppingCartPage> {

  final ScrollController _controller = ScrollController();
  bool _visible = true;
  late String coinType;

  @override
  void initState() {

    setState(() {
      coinType = ShoppingCartProvider().whatCoin();
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
    final prices = ref.watch(coinPrices);

    return Scaffold(
      appBar: showAppBar('Carrito de la compra', actions: [
        IconButton(
          onPressed: (){
            if(rProdList.products.isNotEmpty){
              Navigator.pushNamed(context, 'finish_order_page', arguments: [
                coinType, prices.mlc, prices.usd
              ]);
            }
          }, 
          icon: const Icon(Icons.shopping_cart_checkout_rounded))
      ]),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                dosisText('Moneda de pago: ', size: 20, fontWeight: FontWeight.bold),
                popupMenuButton()
              ],
            ),

            customGroupBox('Información del carrito', [
              dosisBold('Cantidad de productos: ', rProdList.productsCant.toString(), 20),
              dosisBold('Monto de la compra: ', '${(rProdList.whatCoin() == coinType)
                ? rProdList.totalAmount
                : calculatePurchaseAmount(ref, coinType, rProdList.totalAmount)} $coinType', 20),
              dosisBold('Comisión: ', '${rProdList.totalCommissionMoney(ref)} CUP', 20)
            ]),

            ( rProdList.products.isEmpty )
              ? emptyCart(size)
              : Flexible(child: shoppingCartList(rProdList)

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
                    product.coin,
                    product.price,
                    product.inStock.toStringAsFixed(0)),
              
                  const Spacer(),
              
                  addBuyBtn(product.id)
              
                ],
              ),const SizedBox(height: 5),
        
              btnCant(rProdList, product)

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
  
  Container productInfo(String name, String coin, double price, String stock) {

    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dosisText(name, fontWeight: FontWeight.bold),
          dosisText('Precio: \$${(coin == coinType)
            ? price
            : calculatePurchaseAmount(ref, coinType, price)} $coin', color: Colors.blue),
          dosisText('Stock: $stock', color: Colors.green)
        ],
      )
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

  PopupMenuButton popupMenuButton() {
    return PopupMenuButton(
      icon: dosisText(coinType, fontWeight: FontWeight.bold),
      onSelected: (value) {

        Map<String, void Function()> methods = {

          'CUP': (){
            setState(() {
              coinType = 'CUP';
            });
          },
          'MLC': (){
            setState(() {
              coinType = 'MLC';
            });
          },
          'USD': (){
            setState(() {
              coinType = 'USD';
            });
          },
          'ZELLE': (){
            setState(() {
              coinType = 'ZELLE';
            });
          },

        };

        methods[value]!.call();
      
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'CUP',
          child: dosisText('CUP'),
        ),
        PopupMenuItem(
          value: 'MLC',
          child: dosisText('MLC'),
        ),
        PopupMenuItem(
          value: 'USD',
          child: dosisText('USD'),
        ),
        PopupMenuItem(
          value: 'ZELLE',
          child: dosisText('ZELLE'),
        ),
      ],
    );
  }

  Row btnCant(ShoppingCartProvider rProdList, Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
            
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
    
    );
  }

}