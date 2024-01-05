import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/products_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
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
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();
  TextEditingController commissionCtrl = TextEditingController();
  TextEditingController inStockCtrl = TextEditingController();
  TextEditingController discountCtrl = TextEditingController();
  TextEditingController moreThanCtrl = TextEditingController();
  TextEditingController photoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Nuevo producto', centerTitle: false, actions: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.transparent,
          )),
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

            productCtrl.saveProducts(product);
            reloadProducts.value = !reloadProducts.value;
            Navigator.pop(context, true);

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
                  suffixIcon: Icons.add_photo_alternate_outlined, 
                  label: 'Foto del producto'),

                FormTxt(
                  suffixIcon: Icons.text_fields_outlined,
                  controller: nameCtrl, 
                  label: 'Nombre del producto'),
                
                FormTxt(
                  suffixIcon: Icons.text_fields_outlined,
                  controller: descriptionCtrl, 
                  label: 'Breve descripción'),
                
                FormTxt(
                  suffixIcon: Icons.numbers_outlined,
                  controller: priceCtrl, 
                  keyboardType: TextInputType.number,
                  label: 'Precio por unidad'),

                FormTxt(
                  suffixIcon: Icons.numbers_outlined,
                  controller: inStockCtrl,
                  keyboardType: TextInputType.number, 
                  label: 'Cantidad de unidades'),

                FormTxt(
                  suffixIcon: Icons.numbers_outlined,
                  controller: commissionCtrl,
                  keyboardType: TextInputType.number, 
                  label: 'Comisión de ganancia'),

                customGroupBox('Oferta a compra mayorista', [
                  FormTxt(
                    suffixIcon: Icons.numbers_outlined,
                    controller: moreThanCtrl,
                    keyboardType: TextInputType.number,
                    label: 'Cantidad mayorista'),
                  
                  FormTxt(
                    suffixIcon: Icons.numbers_outlined,
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
    required this.controller,
    required this.label, required this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final IconData suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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