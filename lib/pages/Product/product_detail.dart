import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/helpers/check_url.dart';
import 'package:gustazo_cubano_app/models/product_model.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController providerCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController commissionCtrl = TextEditingController();
  TextEditingController inStockCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();
  TextEditingController commissionDiscountCtrl = TextEditingController();
  TextEditingController moreThanCtrl = TextEditingController();
  TextEditingController photoCtrl = TextEditingController();
  TextEditingController boxCtrl = TextEditingController();
  TextEditingController weigthCtrl = TextEditingController();

  bool show = false;
  String coinType = 'CUP';

  bool allowEdit = true;

  String weightType = 'Kg';
  String weightValue = 'Kilogramos';

  String sellType = 'unity';
  String groupValue = 'Por Unidad';

  @override
  void initState() {
    LoginDataService().getRole().then((value) {
      if (value == 'admin') {
        setState(() {
          show = true;
        });
      }
    });

    nameCtrl.text = widget.product.name;
    descriptionCtrl.text = widget.product.description;
    providerCtrl.text = widget.product.provider;
    boxCtrl.text = widget.product.box.toString();
    weigthCtrl.text = widget.product.weigth.toString();
    sellType = widget.product.sellType;
    priceCtrl.text = widget.product.price.toString();
    coinType = widget.product.coin;
    commissionCtrl.text = widget.product.commission.toString();
    commissionDiscountCtrl.text = widget.product.commissionDiscount.toString();
    inStockCtrl.text = widget.product.inStock.toString();
    discountCtrl.text = widget.product.discount.toString();
    moreThanCtrl.text = widget.product.moreThan.toString();
    photoCtrl.text = widget.product.photo;
    weightValue = widget.product.weigthType;

    if(widget.product.sellType == 'unity'){
      groupValue = 'Por Unidad';
    }
    if(widget.product.sellType == 'box'){
      groupValue = 'Por Cajas';
    }
    if(widget.product.sellType == 'weight'){
      groupValue = 'Por Peso';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        reloadProducts.value = !reloadProducts.value;
      },
      child: Scaffold(
        appBar: showAppBar('Detalles del producto', centerTitle: false, actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  allowEdit = !allowEdit;
                });
              },
              icon: const Icon(Icons.mode_edit_outline_outlined)),
          Visibility(
            visible: !allowEdit,
            child: IconButton(
              onPressed: () async {
                final productCtrl = ProductControllers();

                if (nameCtrl.text.isEmpty ||
                  providerCtrl.text.isEmpty ||
                  discountCtrl.text.isEmpty ||
                  discountCtrl.text == '0' ||
                  moreThanCtrl.text.isEmpty ||
                  moreThanCtrl.text == '0') {
                  simpleMessageSnackBar(context, texto: 'Rellene todos los campos por favor', typeMessage: false);
                  return;
                }

                if(weightValue == 'unity'){
                  if( priceCtrl.text.isEmpty || 
                      priceCtrl.text == '0' || 
                      inStockCtrl.text.isEmpty ||
                      inStockCtrl.text == '0' ){
                        simpleMessageSnackBar(context, texto: 'Rellene todos los campos por favor', typeMessage: false);
                        return;
                      }
                } else if(weightValue == 'box'){
                  if( priceCtrl.text.isEmpty || 
                      priceCtrl.text == '0' || 
                      inStockCtrl.text.isEmpty ||
                      inStockCtrl.text == '0' ||
                      boxCtrl.text.isEmpty ||
                      boxCtrl.text == '0' ){
                        simpleMessageSnackBar(context, texto: 'Rellene todos los campos por favor', typeMessage: false);
                        return;
                      }
                } else if(weightValue == 'weight'){
                  if( priceCtrl.text.isEmpty || 
                      priceCtrl.text == '0' || 
                      weigthCtrl.text.isEmpty ||
                      weigthCtrl.text == '0' || 
                      inStockCtrl.text == '0' ){
                        simpleMessageSnackBar(context, texto: 'Rellene todos los campos por favor', typeMessage: false);
                        return;
                      }
                }

                if (show) {
                  if (commissionCtrl.text.isEmpty ||
                      commissionCtrl.text == '0' ||
                      commissionDiscountCtrl.text.isEmpty ||
                      commissionDiscountCtrl.text == '0') {
                    simpleMessageSnackBar(context, texto: 'Rellene todos los campos por favor', typeMessage: false);
                    return;
                  }
                }

                if (photoCtrl.text.isNotEmpty && !checkUrl(photoCtrl.text)) {
                  simpleMessageSnackBar(context, texto: 'La URL de la foto no es válida', typeMessage: false);
                  return;
                }

                String name = nameCtrl.text;
                String description = descriptionCtrl.text;
                String provider = providerCtrl.text;
                String photo = photoCtrl.text;
                double? price = priceCtrl.text.doubleTryParsed;
                double? inStock = inStockCtrl.text.doubleTryParsed;
                double? commission = commissionCtrl.text.doubleTryParsed;
                double? commissionDiscount = commissionCtrl.text.doubleTryParsed;
                int? moreThan = moreThanCtrl.text.intTryParsed;
                double? discount = discountCtrl.text.doubleTryParsed;
                double? box = boxCtrl.text.doubleTryParsed;
                double? weigth = weigthCtrl.text.doubleTryParsed;

                Map<String, dynamic> product = {
                  'name': name,
                  'sellType': sellType,
                  'description': description,
                  'provider': provider,
                  'photo': photo,
                  'price': price,
                  'coin': coinType,
                  'inStock': inStock,
                  'commission': commission,
                  'more_than': moreThan,
                  'discount': discount,
                  'box': box,
                  'weigth': weigth,
                  'weigthType': weightValue,
                  'commissionDiscount': commissionDiscount,
                };

                await productCtrl.editProducts(product, widget.product.id);
                setState(() {
                  allowEdit = !allowEdit;
                });
              },
              icon: const Icon(Icons.save_alt)),
          )
        ]),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  
                  FormTxt(
                    readOnly: allowEdit,
                    controller: photoCtrl,
                    suffixIcon: const Icon(Icons.add_photo_alternate_outlined),
                    label: 'Foto del producto'),
                  
                  FormTxt(
                    readOnly: allowEdit,
                    suffixIcon: const Icon(Icons.text_fields_outlined),
                    controller: nameCtrl,
                    label: 'Nombre del producto'),
                  
                  FormTxt(
                    readOnly: allowEdit,
                    suffixIcon: const Icon(Icons.text_fields_outlined),
                    controller: providerCtrl,
                    label: 'Proveedor del producto'),
                  
                  FormTxt(
                    readOnly: allowEdit,
                    suffixIcon: const Icon(Icons.text_fields_outlined),
                    controller: descriptionCtrl,
                    label: 'Breve descripción'),
                  
                  Visibility(
                    visible: show,
                    child: FormTxt(
                      readOnly: allowEdit,
                      suffixIcon: const Icon(Icons.attach_money_outlined),
                      controller: commissionCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Comisión de ganancia'),
                  ),
                  
                  const SizedBox(height: 20),
                  popupMenuButton2(),

                  paraPeso(),
                  
                  paraCajas(),
                  
                  paraUnidades(),
                  
                  customGroupBox('Oferta a compra mayorista', [
                    FormTxt(
                      readOnly: allowEdit,
                      suffixIcon: const Icon(Icons.numbers_outlined),
                      controller: moreThanCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Cantidad mayorista'),
                    FormTxt(
                      readOnly: allowEdit,
                      suffixIcon: popupMenuButton(),
                      controller: discountCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Precio por unidad'),
                    Visibility(
                      visible: show,
                      child: FormTxt(
                        readOnly: allowEdit,
                        suffixIcon: const Icon(Icons.attach_money_outlined),
                        controller: commissionDiscountCtrl,
                        keyboardType: TextInputType.number,
                        label: 'Comisión de ganancia'),
                    ),
                  ])
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Visibility paraUnidades() {
    return Visibility(
      visible: groupValue == 'Por Unidad',
      child: customGroupBox('Precio y cantidades', [
        FormTxt(
          readOnly: allowEdit,
          suffixIcon: popupMenuButton(),
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          label: 'Precio por Unidad'),

        FormTxt(
          readOnly: allowEdit,
          suffixIcon: const Icon(Icons.numbers_outlined),
          controller: inStockCtrl,
          keyboardType: TextInputType.number,
          label: 'Cantidad de unidades'),
      ]),
    );
  }

  Visibility paraCajas() {
    return Visibility(
      visible: groupValue == 'Por Cajas',
      child: customGroupBox('Precio y cantidades', [
        FormTxt(
          readOnly: allowEdit,
          suffixIcon: popupMenuButton(),
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          label: 'Precio por Unidad'),
        FormTxt(
          readOnly: allowEdit,
          suffixIcon: const Icon(Icons.numbers_outlined),
          controller: boxCtrl,
          keyboardType: TextInputType.number,
          label: 'Unidades por Caja'),
        FormTxt(
          readOnly: allowEdit,
          suffixIcon: const Icon(Icons.numbers_outlined),
          controller: inStockCtrl,
          keyboardType: TextInputType.number,
          label: 'Cantidad de Cajas'),
      ]),
    );
  }

  Visibility paraPeso() {
    return Visibility(
      visible: groupValue == 'Por Peso',
      child: customGroupBox('Precio y cantidades', [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            dosisText('Unidad de Peso:', fontWeight: FontWeight.bold),
            const SizedBox(width: 30),
            popupMenuButton3()
          ],
        ),
      
        FormTxt(
          readOnly: allowEdit,
          suffixIcon: popupMenuButton(),
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          label: 'Precio por $weightValue'),
          
        FormTxt(
          readOnly: allowEdit,
          suffixIcon: const Icon(Icons.numbers_outlined),
          controller: weigthCtrl,
          keyboardType: TextInputType.number,
          label: 'Peso del paquete'),

        FormTxt(
          readOnly: allowEdit,
          suffixIcon: const Icon(Icons.numbers_outlined),
          controller: inStockCtrl,
          keyboardType: TextInputType.number,
          label: 'Total de paquetes en stock'),
      ]),
    );
  }

  PopupMenuButton popupMenuButton() {
    return PopupMenuButton(
      icon: dosisText(coinType, fontWeight: FontWeight.bold),
      onSelected: (value) {
        Map<String, void Function()> methods = {
          'CUP': () {
            setState(() {
              coinType = 'CUP';
            });
          },
          'MLC': () {
            setState(() {
              coinType = 'MLC';
            });
          },
          'USD': () {
            setState(() {
              coinType = 'USD';
            });
          },
          'ZELLE': () {
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
  
  PopupMenuButton popupMenuButton2() {
    return PopupMenuButton(
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          dosisText('Medida de Venta: ', fontWeight: FontWeight.bold),

          const SizedBox(width: 30),
          (groupValue == 'Por Unidad' )
            ? const Icon(Icons.one_x_mobiledata_rounded) 
            : (groupValue == 'Por Cajas' )
              ? const Icon(Icons.breakfast_dining_outlined) 
              : const Icon(Icons.balance),
          const SizedBox(width: 10),
          dosisText(groupValue, fontWeight: FontWeight.bold),
        ],
      ),
      onSelected: (value) {
        Map<String, void Function()> methods = {
          'unity': () {
            setState(() {
              groupValue = 'Por Unidad';
              sellType = 'unity';
            });
          },
          'box': () {
            setState(() {
              groupValue = 'Por Cajas';
              sellType = 'box';
            });
          },
          'weight': () {
            setState(() {
              groupValue = 'Por Peso';
              sellType = 'weight';
            });
          },
        };

        methods[value]!.call();
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'unity',
          child: ListTile(
            leading: const Icon(Icons.one_x_mobiledata_rounded),
            title: dosisText('Por Unidad'),
          )
        ),
        PopupMenuItem(
          value: 'box',
          child: ListTile(
            leading: const Icon(Icons.breakfast_dining_outlined),
            title: dosisText('Por Cajas'),
          )
        ),
        PopupMenuItem(
          value: 'weight',
          child: ListTile(
            leading: const Icon(Icons.balance),
            title: dosisText('Por Peso'),
          )
        ),
      ],
    );
  }

  PopupMenuButton popupMenuButton3() {
    return PopupMenuButton(
      icon: dosisText(weightValue, fontWeight: FontWeight.bold),
      onSelected: (value) {
        Map<String, void Function()> methods = {
          'Kg': () {
            setState(() {
              weightType = 'Kg';
              weightValue = 'Kilogramos';
            });
          },
          'Lb': () {
            setState(() {
              weightType = 'Lb';
              weightValue = 'Libras';
            });
          },
          'Gr': () {
            setState(() {
              weightType = 'Gr';
              weightValue = 'Gramos';
            });
          }
        };

        methods[value]!.call();
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 'Kg',
          child: dosisText('Kilogramos'),
        ),
        PopupMenuItem(
          value: 'Lb',
          child: dosisText('Libras'),
        ),
        PopupMenuItem(
          value: 'Gr',
          child: dosisText('Gramos'),
        )
      ],
    );
  }
 
}

class FormTxt extends StatelessWidget {
  const FormTxt({
    super.key,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    required this.controller,
    required this.label,
    required this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final Widget suffixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold),
          labelText: label,
        ));
  }
}
