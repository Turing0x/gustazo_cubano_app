import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:gustazo_cubano_app/config/controllers/orders_controllers.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ConfirmPendingPage extends StatefulWidget {
  const ConfirmPendingPage({super.key,
    required this.orderId});

  final String orderId;

  @override
  State<ConfirmPendingPage> createState() => _ConfirmPendingPageState();
}

class _ConfirmPendingPageState extends State<ConfirmPendingPage> {

  TextEditingController invoceNumber = TextEditingController();
  String diames = '';

  @override
  void initState() {
    DateTime dateTime = DateTime.now();
    invoceNumber.text = '${dateTime.day}${dateTime.month}';
    diames = '${dateTime.day}${dateTime.month}';
    super.initState();
  }

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
                    top: size.width * .15,
                    bottom: 20),
                child: Image.asset('lib/assets/images/3891942.jpg'),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: dosisText(
                  'Los productos han sido entregados con éxito. Para finalizar el pedido, por favor ingresa el número de factura en el campo a continuación.', 
                  size: 18, maxLines: 4, textAlign: TextAlign.center),
              ),

              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
                child: FormTxt(
                  controller: invoceNumber, 
                  label: 'Número de factura'),
              ),

              ElevatedButton.icon(
                onPressed: (){

                  String number = invoceNumber.text;
                  if( number.isEmpty ){
                    simpleMessageSnackBar(context, 
                      texto: 'Debe escribir el número de la factura en el campo disponible',
                      typeMessage: false);
                    return;
                  }

                  if( number.split(' - ')[0] != diames || number.length < 9 ){
                    simpleMessageSnackBar(context, 
                      texto: 'El número de la factura introducido es incorrecto. Verifíquelo por favor.',
                      typeMessage: false);
                    return;
                  }

                  final orderCtrl = OrderControllers();
                  orderCtrl.marckAsDoneOrder(widget.orderId, number).then((value) {
                    if(value){
                      Navigator.pushReplacementNamed(context, 'pendings_control_page');
                    }
                  });
                }, 
                icon: const Icon(Icons.done_outline_rounded, color: Colors.green), 
                label: dosisText('Confirmar', fontWeight: FontWeight.bold)
              ),

              const SizedBox(height: 50),

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
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        MaskedInputFormatter('#### - ###'),
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontFamily: 'Dosis',
          fontWeight: FontWeight.bold),
        labelText: label,
      )
    );
  }
}