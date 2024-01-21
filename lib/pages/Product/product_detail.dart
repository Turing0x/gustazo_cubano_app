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
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController providerCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController commissionCtrl = TextEditingController();
  TextEditingController commissionDiscountCtrl = TextEditingController();
  TextEditingController inStockCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();
  TextEditingController moreThanCtrl = TextEditingController();
  TextEditingController photoCtrl = TextEditingController();

  bool allowEdit = true;
  bool show = false;

  @override
  void initState() {

    LoginDataService().getRole().then((value) {
      if(value == 'admin'){
        setState(() {show = true;});
      }
    });

    nameCtrl.text = widget.product.name;
    descriptionCtrl.text = widget.product.description;
    providerCtrl.text = widget.product.provider;
    priceCtrl.text = widget.product.price.toString();
    commissionCtrl.text = widget.product.commission.toString();
    commissionDiscountCtrl.text = widget.product.commissionDiscount.toString();
    inStockCtrl.text = widget.product.inStock.toString();
    discountCtrl.text = widget.product.discount.toString();
    moreThanCtrl.text = widget.product.moreThan.toString();
    photoCtrl.text = widget.product.photo;
    
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
            onPressed: (){
              setState(() {
                allowEdit = !allowEdit;
              });
            }, 
            icon: const Icon(Icons.mode_edit_outline_outlined)
          ),
      
          Visibility(
            visible: !allowEdit,
            child: IconButton(
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
                    texto: 'Parte de la información es incorrecta, por favor revise los campos',
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

                if(!checkUrl(photoCtrl.text)){
                  simpleMessageSnackBar(context, 
                    texto: 'La URL de la foto no es válida',
                    typeMessage: false);
                  return;
                }
      
                String name = nameCtrl.text;
                String description = descriptionCtrl.text;
                String provider = providerCtrl.text;
                String photo = photoCtrl.text;
                double price = priceCtrl.text.doubleParsed;
                double inStock = inStockCtrl.text.doubleParsed;
                double commission = commissionCtrl.text.doubleParsed;
                double commissionDiscount = commissionDiscountCtrl.text.doubleParsed;
                int moreThan = moreThanCtrl.text.intParsed;
                double discount = discountCtrl.text.doubleParsed;
      
                Map<String, dynamic> product = {
                  'name': name,
                  'description': description,
                  'provider': provider,
                  'photo': photo,
                  'price': price,
                  'inStock': inStock,
                  'commission': commission,
                  'commissionDiscount': commissionDiscount,
                  'more_than': moreThan,
                  'discount': discount,
                };
      
                await productCtrl.editProducts(product, widget.product.id);
                setState(() {
                  allowEdit = false;
                });
              }, 
              icon: const Icon(Icons.save_alt)
            ),
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
                    controller: photoCtrl,
                    suffixIcon: Icons.add_photo_alternate_outlined, 
                    readOnly: allowEdit,
                    label: 'Foto del producto'),
      
                  FormTxt(
                    suffixIcon: Icons.text_fields_outlined,
                    readOnly: allowEdit,
                    controller: nameCtrl, 
                    label: 'Nombre del producto'),
      
                  FormTxt(
                    suffixIcon: Icons.text_fields_outlined,
                    readOnly: allowEdit,
                    controller: providerCtrl, 
                    label: 'Proveedor del producto'),
                  
                  FormTxt(
                    suffixIcon: Icons.text_fields_outlined,
                    readOnly: allowEdit,
                    controller: descriptionCtrl, 
                    label: 'Breve descripción'),
                  
                  FormTxt(
                    suffixIcon: Icons.attach_money_outlined,
                    readOnly: allowEdit,
                    controller: priceCtrl, 
                    keyboardType: TextInputType.number,
                    label: 'Precio por unidad'),
      
                  FormTxt(
                    suffixIcon: Icons.numbers_outlined,
                    readOnly: allowEdit,
                    controller: inStockCtrl,
                    keyboardType: TextInputType.number, 
                    label: 'Cantidad de unidades'),
      
                  Visibility(
                    visible: show,
                    child: FormTxt(
                      suffixIcon: Icons.attach_money_outlined,
                      readOnly: allowEdit,
                      controller: commissionCtrl,
                      keyboardType: TextInputType.number, 
                      label: 'Comisión de ganancia'),
                  ),
      
                  customGroupBox('Oferta a compra mayorista', [
                    FormTxt(
                      suffixIcon: Icons.numbers_outlined,
                      readOnly: allowEdit,
                      controller: moreThanCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Cantidad mayorista'),
                    
                    FormTxt(
                      suffixIcon: Icons.attach_money_outlined,
                      readOnly: allowEdit,
                      controller: discountCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Precio de venta'),
                    
                    FormTxt(
                      suffixIcon: Icons.attach_money_outlined,
                      readOnly: allowEdit,
                      controller: commissionDiscountCtrl,
                      keyboardType: TextInputType.number,
                      label: 'Comisión de ganancia'),
                  ])
              
                ],
              ),
            ),
      
          ),
      
        ),
      
      ),
    );

  }

}

class FormTxt extends StatelessWidget {
  const FormTxt({
    super.key,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    required this.controller,
    required this.label, required this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final IconData suffixIcon;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        suffixIcon: Icon(suffixIcon),
        labelStyle: const TextStyle(
          fontFamily: 'Dosis',
          fontWeight: FontWeight.bold),
        labelText: label,
      )
    );
  }
}