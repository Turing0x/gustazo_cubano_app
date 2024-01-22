import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/coins_controllers.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ChangeCoinsPage extends StatefulWidget {
  const ChangeCoinsPage({super.key});

  @override
  State<ChangeCoinsPage> createState() => _ChangeCoinsPageState();
}

class _ChangeCoinsPageState extends State<ChangeCoinsPage> {
  
  TextEditingController mlcCtrl = TextEditingController();
  TextEditingController usdCtrl = TextEditingController();
  
  @override
  void initState() {
    CoinControllers().getAllCoins().then((value) {
      if(value.isNotEmpty){
        setState(() {
          mlcCtrl.text = value[0].mlc.numFormat;
          usdCtrl.text = value[0].usd.numFormat;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: showAppBar('Cambios de modena'),
      body: Column(
        children: [

          FormTxt(
            suffixIcon: dosisText('MLC', fontWeight: FontWeight.bold),
            controller: mlcCtrl, 
            label: 'Cambio respecto al CUP'),

          FormTxt(
            suffixIcon: dosisText('USD', fontWeight: FontWeight.bold),
            controller: usdCtrl, 
            label: 'Cambio respecto al CUP'),

          const SizedBox(height: 20),

          ElevatedButton.icon(
            onPressed: () async{
              final coin = {
                'mlc': mlcCtrl.text,
                'usd': usdCtrl.text
              };
              await CoinControllers().saveCoins(coin);
            }, 
            icon: const Icon(Icons.done_outline_rounded, color: Colors.green), 
            label: dosisText('Confirmar', fontWeight: FontWeight.bold)
          )

        ],
      ),
    );
  }
}

class FormTxt extends StatelessWidget {
  const FormTxt({
    super.key,
    required this.controller,
    required this.label, required this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final Widget suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(top: 20),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          labelStyle: const TextStyle(
            fontFamily: 'Dosis',
            fontWeight: FontWeight.bold),
          labelText: label,
        )
      ),
    );
  }
}