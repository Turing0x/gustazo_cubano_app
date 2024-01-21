import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/users_controllers.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class ChangeAccessPass extends StatefulWidget {
  const ChangeAccessPass({super.key});

  @override
  State<ChangeAccessPass> createState() => _ChangeAccessPassState();
}

class _ChangeAccessPassState extends State<ChangeAccessPass> {

  TextEditingController actualPass = TextEditingController();
  TextEditingController newPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final nav = Navigator.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
          
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context), 
                  icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              
              Container(
                height: size.height * 0.45,
                margin: EdgeInsets.only(
                  left: size.width * .05,
                  right: size.width * .05,
                  bottom: 10),
                child: Image.asset('lib/assets/images/change_pass.jpg'),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: dosisText(
                  'Proporcione la información necesaria para cambiar su contaseña', 
                  size: 18, maxLines: 4, textAlign: TextAlign.center),
              ),
              
              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: FormTxt(
                  controller: actualPass, 
                  keyboardType: TextInputType.name,
                  label: 'Contraseña Actual'),
              ),
          
              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: FormTxt(
                  controller: newPass, 
                  keyboardType: TextInputType.name,
                  label: 'Nueva Contraseña'),
              ),
          
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: () async{
                  final userCtrl = UserControllers();
                    bool status = await userCtrl.changePass(actualPass.text, newPass.text);
                  
                    if(status){
                      nav.pushNamedAndRemoveUntil('auth_page', (route) => false);
                    }

                }, 
                icon: const Icon(Icons.done_outline_rounded, color: Colors.green), 
                label: dosisText('Confirmar', fontWeight: FontWeight.bold)
              )

            ],
          ),
        ),
      ),
    );
  }

  void goPage(String page) => Navigator.popAndPushNamed(context, page);
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