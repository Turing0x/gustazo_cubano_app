import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/models/user_model.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class CommercialInfoPage extends StatelessWidget {
  const CommercialInfoPage({super.key, required this.commercial});

  final User commercial;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar('Información del comercial'),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            dosisText(commercial.personalInfo.fullName, size: 23),
            dosisBold('Código de comercial: ', commercial.commercialCode, 23),
            dosisBold('Nombre de usuario: ', commercial.username, 23),

            dosisBold('Carnet de identidad: ', commercial.personalInfo.ci, 23),
            dosisBold('Dirección particular: ', commercial.personalInfo.address, 23),
            dosisBold('Número de celular: ', commercial.personalInfo.phone, 23),
          ],
        ),
      ),
    );
  }
}