import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/shopping_cart_provider.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class BuyerInfoPage extends StatefulWidget {
  const BuyerInfoPage({super.key, required this.dataOrder});

  final Map<String, dynamic> dataOrder;

  @override
  State<BuyerInfoPage> createState() => _BuyerInfoPageState();
}

class _BuyerInfoPageState extends State<BuyerInfoPage> {

  TextEditingController fullname = TextEditingController();
  TextEditingController ci = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.arrow_back_ios_new)),
              ),

              Container(
                height: size.height * 0.35,
                margin: EdgeInsets.only(
                    left: size.width * .05,
                    right: size.width * .05,
                    bottom: 20),
                child: Image.asset('lib/assets/images/buyer_info.jpg'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: dosisText(
                  'Necesitamos que nos facilites información acerca del comprador', 
                  size: 18, maxLines: 4, textAlign: TextAlign.center),
              ),

              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: FormTxt(
                  controller: fullname, 
                  keyboardType: TextInputType.name,
                  label: 'Nombre completo'),
              ),

              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: FormTxt(
                  controller: ci, 
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  label: 'Carnet de identidad'),
              ),

              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: FormTxt(
                  controller: address, 
                  keyboardType: TextInputType.name,
                  label: 'Dirección particular'),
              ),
              
              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: FormTxt(
                  controller: phoneNumber,
                  maxLength: 8,
                  keyboardType: TextInputType.phone,
                  label: 'Teléfono de contacto'),
              ),

              ElevatedButton.icon(
                onPressed: () async{
      
                  final orderCrtl = OrderControllers();
                  final rProdList = ShoppingCartProvider();

                  String getfullname = fullname.text;
                  String getci = ci.text;
                  String getaddress = address.text;
                  String getphoneNumber = phoneNumber.text;
                  
                  if( getfullname.isEmpty || 
                      getci.isEmpty ||
                      getaddress.isEmpty ||
                      getphoneNumber.isEmpty){
                    simpleMessageSnackBar(context, 
                      texto: 'Ambos campos son obligatorios',
                      typeMessage: false);
                    return;
                  }

                  widget.dataOrder.addAll({
                    'buyer': {
                      'full_name': getfullname,
                      'ci': getci,
                      'phone_number': getphoneNumber,
                      'address': getaddress,
                    }
                  });

                  orderCrtl.saveOrder(widget.dataOrder);
                  rProdList.cleanCart();
                  Navigator.pushReplacementNamed(context, 'main_commercial_page');
                  
                }, 
                icon: const Icon(Icons.done_outline_rounded, color: Colors.green), 
                label: dosisText('Confirmar', fontWeight: FontWeight.bold)
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
      ),
    );
  }
}

class FormTxt extends StatelessWidget {
  const FormTxt({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.label,
    this.maxLength = 25,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontFamily: 'Dosis',
          fontWeight: FontWeight.bold),
        labelText: label,
      )
    );
  }
}