import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/database/entities/login_data_service.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/helpers/check_url.dart';
import 'package:gustazo_cubano_app/shared/group_box.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class CreateProductPage extends StatefulWidget {
  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {

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

  bool show = false;
  String coinType = 'CUP';

  @override
  void initState() {
    LoginDataService().getRole().then((value) {
      if(value == 'admin'){
        setState(() {show = true;});
      }
    });
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
        appBar: showAppBar('Nuevo producto', centerTitle: false, actions: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: Colors.transparent,
            )),
            onPressed: () async{
        
              final productCtrl = ProductControllers();
      
              if( nameCtrl.text.isEmpty || 
                  priceCtrl.text.isEmpty || 
                  priceCtrl.text == '0' || 
                  providerCtrl.text.isEmpty || 
                  inStockCtrl.text.isEmpty || 
                  inStockCtrl.text == '0' || 
                  discountCtrl.text.isEmpty || 
                  discountCtrl.text == '0' || 
                  moreThanCtrl.text.isEmpty || 
                  moreThanCtrl.text == '0'){
                simpleMessageSnackBar(context, 
                  texto: 'Rellene todos los campos por favor',
                  typeMessage: false);
                return;
              }

              if(show){
                if( commissionCtrl.text.isEmpty ||
                  commissionCtrl.text == '0' ||
                  commissionDiscountCtrl.text.isEmpty ||
                  commissionDiscountCtrl.text == '0'){
                    simpleMessageSnackBar(context, 
                      texto: 'Rellene todos los campos por favor',
                      typeMessage: false);
                    return;
                  }
              }

              if( photoCtrl.text.isNotEmpty && !checkUrl(photoCtrl.text)){
                simpleMessageSnackBar(context, 
                  texto: 'La URL de la foto no es válida',
                  typeMessage: false);
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

              Map<String, dynamic> product = {
                'name': name,
                'description': description,
                'provider': provider,
                'photo': photo,
                'price': price,
                'coin': coinType,
                'inStock': inStock,
                'commission': commission,
                'more_than': moreThan,
                'discount': discount,
                'commissionDiscount': commissionDiscount,
              };
      
              await productCtrl.saveProducts(product);
      
              nameCtrl.text = '';
              descriptionCtrl.text = '';
              providerCtrl.text = '';
              priceCtrl.text = '';
              commissionCtrl.text = '';
              inStockCtrl.text = '';
              discountCtrl.text = '';
              commissionDiscountCtrl.text = '';
              moreThanCtrl.text = '';
              photoCtrl.text = '';
      
            }, 
            icon: const Icon(Icons.done, color: Colors.white,), 
            label: dosisText('Listo', color: Colors.white))
        ]),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
              
                  FormTxt(
                    controller: photoCtrl,
                    suffixIcon: const Icon(Icons.add_photo_alternate_outlined), 
                    label: 'Foto del producto'),
      
                  FormTxt(
                    suffixIcon: const Icon(Icons.text_fields_outlined),
                    controller: nameCtrl, 
                    label: 'Nombre del producto'),

                  FormTxt(
                    suffixIcon: const Icon(Icons.text_fields_outlined),
                    controller: providerCtrl, 
                    label: 'Proveedor del producto'),
                  
                  FormTxt(
                    suffixIcon: const Icon(Icons.text_fields_outlined),
                    controller: descriptionCtrl, 
                    label: 'Breve descripción'),
                  
                  FormTxt(
                    suffixIcon: popupMenuButton(),
                    controller: priceCtrl, 
                    keyboardType: TextInputType.number,
                    label: 'Precio por unidad'),
      
                  FormTxt(
                    suffixIcon: const Icon(Icons.numbers_outlined),
                    controller: inStockCtrl,
                    keyboardType: TextInputType.number, 
                    label: 'Cantidad de unidades'),
      
                  Visibility(
                    visible: show,
                    child: FormTxt(
                      suffixIcon: const Icon(Icons.attach_money_outlined),
                      controller: commissionCtrl,
                      keyboardType: TextInputType.number, 
                      label: 'Comisión de ganancia'),
                  ),
      
                  customGroupBox('Oferta a compra mayorista', [
                    FormTxt(
                      suffixIcon: const Icon(Icons.numbers_outlined),
                      controller: moreThanCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Cantidad mayorista'),
                    
                    FormTxt(
                      suffixIcon: popupMenuButton(),
                      controller: discountCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Precio por unidad'),

                    Visibility(
                      visible: show,
                      child: FormTxt(
                        suffixIcon: const Icon(Icons.attach_money_outlined),
                        controller: commissionDiscountCtrl,
                        keyboardType: TextInputType.number,
                        label: 'Comisión de ganancia'),
                    ),
                  ])
              
                ],
              ),
            ),
          ),
        ),
      ),
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

}

class FormTxt extends StatelessWidget {
  const FormTxt({
    super.key,
    this.keyboardType = TextInputType.text,
    required this.controller,
    required this.label, required this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelStyle: const TextStyle(
          fontFamily: 'Dosis',
          fontWeight: FontWeight.bold),
        labelText: label,
      )
    );
  }
}