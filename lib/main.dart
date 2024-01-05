import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/router/on_generate_route.dart';
import 'package:gustazo_cubano_app/config/router/routes.dart';
import 'package:gustazo_cubano_app/config/utils/initial_route.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  await dotenv.load(fileName: '.env');

  final rutIni = await initialRoute();
  initializeDateFormatting();

  runApp(ProviderScope(
    child: MyApp(
      rutaInicial: rutIni,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,
    required this.rutaInicial, 
  });

  final String rutaInicial;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E Gustazo Cubano',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: rutaInicial,
      routes: appRoutes,
      onGenerateRoute: onGenerateRoute,
      builder: EasyLoading.init(),
    );
  }
}
