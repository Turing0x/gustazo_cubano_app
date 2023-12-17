import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/users_controllers.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/shared/show_snackbar.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthPageState();
}

class _AuthPageState extends ConsumerState<AuthPage> {  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      

      body: Stack(
        children: [
          CustomPaint(
            painter: CurvePainter(),
            child: Container(),
          ),

          SafeArea(
           
            child: SingleChildScrollView(
              child: Center(
              
                child: Column(
              
                  children: [
                    
                    const SizedBox(height: 50),
                    mainTitle(),
                    dosisText('SIEMPRE CONTIGO', size: 20, color: Colors.white),
                    
                    const SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: dosisText('Complete los campos para acceder al sistema', 
                        size: 22,
                        textAlign: TextAlign.center,
                        maxLines: 2, color: Colors.white),
                    ),
              
                    const AuthForm(),

                    const SizedBox(height: 30),
                    dosisText('Olvidaste la contraseña?', color: Colors.black),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.spatial_audio_outlined),
                      onPressed: (){}, 
                      label: dosisText('Informar', color: Colors.black)
                    ),
                    const SizedBox(height: 30),
              
                  ],
              
                ),
              
              ),
            )

          )

        ],

      )

    );

  }

  Text mainTitle() {
    return const Text(
      "E' Gustazo Cubano",
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Dosis',
        fontSize: 27,
        wordSpacing: 5, 
        decoration: TextDecoration.underline,
        decorationColor: Colors.white,
      )
    );
  }

}

class AuthForm extends ConsumerStatefulWidget {
  const AuthForm({
    super.key
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthFormState();
}

class _AuthFormState extends ConsumerState<AuthForm> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final btnManager = ref.watch(btnManagerR);

    Map<String, void Function()> routesByRole = {
      'admin': () =>
          Navigator.pushReplacementNamed(context, 'main_admin_page'),
      'commercial': () =>
          Navigator.pushReplacementNamed(context, 'main_commercial_page'),
    };

    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: size.width * .8,
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 1,
            blurRadius: 3,
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: [
        
            dosisText('Cuenta de acceso', 
              size: 25, 
              fontWeight: FontWeight.bold, 
              color: Colors.black),
        
            const SizedBox(height: 15),
            FormTxt(
              username: username, 
              obscureText: false,
              label: 'Nombre de usuario'),
    
            const SizedBox(height: 10),
    
            FormTxt(
              username: password,
              obscureText: true, 
              label: 'Contraseña'),
    
            AbsorbPointer(
              absorbing: btnManager,
              child: Container(
                margin: const EdgeInsets.only(top: 30),
                width: 200,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        (!btnManager) 
                          ? const Color.fromARGB(255, 91, 79, 226) 
                          : Colors.grey[400],
                    elevation: 2,
                  ),
                  icon: const Icon(Icons.login, 
                    color: Colors.white, size: 20,), 
                  label: dosisText('Acceder', 
                    fontWeight: FontWeight.w500,
                    size: 20, color: Colors.white),
                  onPressed: (){
                    final authService = UserControllers();
                    final btnManagerM = ref.read(btnManagerR.notifier);
              
                    btnManagerM.state = true;
                    FocusScope.of(context).unfocus();
              
                    if (username.text.isEmpty || password.text.isEmpty) {
                      btnManagerM.state = false;
                      return simpleMessageSnackBar(context, texto: 'Debe completar la información de registro');
                    }
              
                    final typeRole = authService.login(
                        username.text.trim(), password.text.trim());
              
                    typeRole.then((value) {
                      if (value != '') {
                        routesByRole[value]!.call();
                      }
                      btnManagerM.state = false;
                    }).catchError((error) {
                      simpleMessageSnackBar(
                        context,
                        texto: 'Ha ocurrido un error al conectar con el servidor. Por favor, revise su conexión a internet');
                      btnManagerM.state = false;
                      return error;
                    });
                  }, 
                ),
              ),
            )
        
          ],
        ),
      ),
    );
  }

}

class FormTxt extends StatelessWidget {
  const FormTxt({
    super.key,
    required this.username,
    required this.label,
    required this.obscureText,
  });

  final TextEditingController username;
  final String label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: username,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelStyle: const TextStyle(
          fontFamily: 'Dosis',
          fontWeight: FontWeight.bold),
        labelText: label,
      )
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(size.width / 2, size.height * 0.7, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    var paint = Paint();
    paint.style = PaintingStyle.fill;

    // Define un gradiente lineal
    var gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF473ACD), 
        Color.fromARGB(255, 115, 93, 215)],
    );

    // Crea un shader a partir del gradiente y el rectángulo delimitador del camino
    paint.shader = gradient.createShader(path.getBounds());

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
