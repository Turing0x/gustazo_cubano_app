import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController fullname = TextEditingController();
  TextEditingController commercialCode = TextEditingController();

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
                child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new)),
              ),
              Container(
                height: size.height * 0.35,
                margin:
                    EdgeInsets.only(left: size.width * .05, right: size.width * .05, top: size.width * .15, bottom: 20),
                child: Image.asset('lib/assets/images/forgot_password.jpg'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: dosisText('Necesitamos que nos facilites cierta información para comprobar tu identidad',
                    size: 18, maxLines: 4, textAlign: TextAlign.center),
              ),
              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
                child: FormTxt(controller: fullname, label: 'Nombre completo'),
              ),
              Container(
                margin: const EdgeInsets.only(left: 40, right: 40, bottom: 30),
                child: FormTxt(controller: commercialCode, label: 'Código de comercial'),
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    String getfullname = fullname.text;
                    String getcommercialCode = commercialCode.text;
                    if (getfullname.isEmpty || getcommercialCode.isEmpty) {
                      simpleMessageSnackBar(context, texto: 'Ambos campos son obligatorios', typeMessage: false);
                      return;
                    }

                    String text =
                        '*Solicitud de reseteo de contraseña*: \n\n*Nombre completo*: ${fullname.text} \n*Código de comercial*: ${commercialCode.text}';

                    final url = 'https://wa.me/+17866699736?text=$text';

                    await launchUrlString(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  icon: const Icon(Icons.done_outline_rounded, color: Colors.green),
                  label: dosisText('Confirmar', fontWeight: FontWeight.bold)),
              const SizedBox(height: 30)
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
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelStyle: const TextStyle(fontFamily: 'Dosis', fontWeight: FontWeight.bold),
          labelText: label,
        ));
  }
}
