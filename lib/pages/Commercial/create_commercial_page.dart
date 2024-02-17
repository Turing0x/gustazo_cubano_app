import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/config/controllers/users_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class CreateCommercialPage extends StatefulWidget {
  const CreateCommercialPage({super.key});

  @override
  State<CreateCommercialPage> createState() => _CreateCommercialPageState();
}

class _CreateCommercialPageState extends State<CreateCommercialPage> {
  TextEditingController fullname = TextEditingController();
  TextEditingController ci = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final focus = FocusScope.of(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        reloadUsers.value = !reloadUsers.value;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child:
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
                ),
                Container(
                  height: size.height * 0.45,
                  margin: EdgeInsets.only(left: size.width * .05, right: size.width * .05, bottom: 10),
                  child: Image.asset('lib/assets/images/new_commercial.jpg'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: dosisText('Necesitamos información personal acerca del comercial para poder hacer su registro',
                      size: 18, maxLines: 4, textAlign: TextAlign.center),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                  child: FormTxt(controller: fullname, keyboardType: TextInputType.name, label: 'Nombre completo'),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                  child: FormTxt(
                      controller: ci, maxLength: 11, keyboardType: TextInputType.number, label: 'Carnet de identidad'),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                  child: FormTxt(
                      controller: address,
                      maxLength: 50,
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
                    onPressed: () async {
                      UserControllers userControllers = UserControllers();

                      if (fullname.text == '' || ci.text == '' || address.text == '' || phoneNumber.text == '') {
                        simpleMessageSnackBar(context,
                            texto: 'Es obligatorio rellenar todos los campos', typeMessage: false);
                        return;
                      }

                      if (ci.text.length != 11) {
                        simpleMessageSnackBar(context,
                            texto: 'El carnet de identidad es incorrecto, rectifíquelo por favor', typeMessage: false);
                        return;
                      }

                      if (phoneNumber.text.length != 8) {
                        simpleMessageSnackBar(context,
                            texto: 'El número de celular es incorrecto, rectifíquelo por favor', typeMessage: false);
                        return;
                      }

                      focus.unfocus();
                      await userControllers.saveUser(fullname.text, ci.text, address.text, phoneNumber.text);

                      fullname.text = '';
                      ci.text = '';
                      address.text = '';
                      phoneNumber.text = '';
                    },
                    icon: const Icon(Icons.done_outline_rounded, color: Colors.green),
                    label: dosisText('Confirmar', fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
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
          labelStyle: const TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold),
          labelText: label,
        ));
  }
}
