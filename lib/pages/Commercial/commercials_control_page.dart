import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/controllers/users_controllers.dart';
import 'package:gustazo_cubano_app/models/user_model.dart';
import 'package:gustazo_cubano_app/shared/no_data.dart';
import 'package:gustazo_cubano_app/shared/shared_dismissible.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class CommercialsControlPage extends StatefulWidget {
  const CommercialsControlPage({super.key});

  @override
  State<CommercialsControlPage> createState() => _CommercialsControlPageState();
}

class _CommercialsControlPageState extends State<CommercialsControlPage> {

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: showAppBar('Equipo de trabajo', actions: [
        IconButton(
          onPressed: (){
            showModalBottomSheet(
              context: context, 
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: [
                
                      dosisText('Registrar comercial', size: 22, fontWeight: FontWeight.bold),
                      FormTxt(
                        username: username, 
                        label: 'Nombre de Usuario', 
                        obscureText: false),
                      FormTxt(
                        username: password, 
                        label: 'Contraseña', 
                        obscureText: false),
                
                      const SizedBox(height: 15),
                  
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 91, 79, 226),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.done_outline_rounded, 
                          color: Colors.white, size: 20,), 
                        label: dosisText('Registrar', 
                          fontWeight: FontWeight.w500,
                          size: 20, color: Colors.white),
                        onPressed: (){
                          UserControllers userControllers = UserControllers();
                          userControllers.saveUser(username.text, password.text);
                        }
                      )
                    ],
                  ),
                );
              },
            );
          }, 
          icon: const Icon(Icons.person_add_alt_outlined)
        )
      ]),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const ShowList()
      ),

    );

  }

}

class ShowList extends ConsumerStatefulWidget {
  const ShowList({super.key});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShowListState();
}

class _ShowListState extends ConsumerState<ShowList> {

  @override
  Widget build(BuildContext context) {

    UserControllers userControllers = UserControllers();

    return Scaffold(
      body: FutureBuilder(
        future: userControllers.getAllCommercials(),
        builder: (context, AsyncSnapshot<List<User>> snapshot) {
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return noData(context, 
              'Parece que aún no tiene comerciales registrado. Para hacerlo, pinche el ícono de la esquina superior derecha');
          }
      
          final users = snapshot.data;
      
          return ListView.builder(
            itemCount: users!.length,
            itemBuilder: (context, index) {
              return CommonDismissible(
                text: 'Eliminar comercial',
                canDissmis: true,
                valueKey: users[index].id,
                onDismissed: (direction) {
                  UserControllers().deleteOne(users[index].id);
                  setState(() {
                    snapshot.data!.remove(users[index]);
                  });
                },
                child: ListTile(
                  minLeadingWidth: 20,
                  title: dosisText(users[index].username, size: 18,
                      fontWeight: FontWeight.bold),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      btnResetPassword(context, users[index].id),
                      btnEnable(users[index].id, users[index].enable)
                    ],
                  ),
                ),
              );
            });
          },
        ),
    );
  }

  IconButton btnResetPassword(BuildContext context, String id) {
    
    return IconButton(
        icon: const Icon(
          Icons.lock_reset_outlined,
          color: Colors.red,
        ),
        onPressed: (){
          UserControllers userControllers = UserControllers();
          userControllers.resetPass(id);
        });
  }

  Switch btnEnable(String id, bool enable) {

    UserControllers userControllers = UserControllers();
    
    bool state = enable;
    return Switch(
      value: state,
      onChanged: (value) async {
        await userControllers.changeEnable(id, value);
        setState(() {
          state = value;
        });
      },
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