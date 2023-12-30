import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
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
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController commissionCtrl = TextEditingController();
  TextEditingController inStockCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();
  TextEditingController moreThanCtrl = TextEditingController();
  TextEditingController photoCtrl = TextEditingController();

  bool allowEdit = true;

  @override
  void initState() {

    nameCtrl.text = widget.product.name;
    descriptionCtrl.text = widget.product.description;
    priceCtrl.text = widget.product.price.toString();
    commissionCtrl.text = widget.product.commission.toString();
    inStockCtrl.text = widget.product.inStock.toString();
    discountCtrl.text = widget.product.discount.toString();
    moreThanCtrl.text = widget.product.moreThan.toString();
    photoCtrl.text = widget.product.photo;
    
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: (){
              final productCtrl = ProductControllers();

              if( nameCtrl.text.isEmpty || 
                  priceCtrl.text.isEmpty || 
                  priceCtrl.text == '0' || 
                  commissionCtrl.text.isEmpty || 
                  commissionCtrl.text == '0' || 
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

              String name = nameCtrl.text;
              String description = descriptionCtrl.text;
              String photo = photoCtrl.text;
              double price = double.parse(priceCtrl.text);
              double inStock = double.parse(inStockCtrl.text);
              double commission = double.parse(commissionCtrl.text);
              int moreThan = int.parse(moreThanCtrl.text);
              double discount = double.parse(discountCtrl.text);

              Map<String, dynamic> product = {
                'name': name,
                'description': description,
                'photo': photo,
                'price': price,
                'inStock': inStock,
                'commission': commission,
                'more_than': moreThan,
                'discount': discount,
              };

              productCtrl.editProducts(product, widget.product.id);
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
                  controller: descriptionCtrl, 
                  label: 'Breve descripción'),
                
                FormTxt(
                  suffixIcon: Icons.numbers_outlined,
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

                FormTxt(
                  suffixIcon: Icons.numbers_outlined,
                  readOnly: allowEdit,
                  controller: commissionCtrl,
                  keyboardType: TextInputType.number, 
                  label: 'Comisión de ganancia'),

                customGroupBox('Oferta a compra mayorista', [
                  FormTxt(
                    suffixIcon: Icons.numbers_outlined,
                    readOnly: allowEdit,
                    controller: moreThanCtrl,
                    keyboardType: TextInputType.number,
                    label: 'Cantidad mayorista'),
                  
                  FormTxt(
                    suffixIcon: Icons.numbers_outlined,
                    readOnly: allowEdit,
                    controller: discountCtrl,
                    keyboardType: TextInputType.number,
                    label: 'Precio de venta'),
                ])
            
              ],
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