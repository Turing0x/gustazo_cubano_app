import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

void simpleMessageSnackBar(BuildContext context,
    {String texto = 'La acción ha sido completada',
    IconData icon = Icons.thumb_up_alt_outlined,
    Color? color = Colors.white,
    bool typeMessage = true}) {
  final snackBar = SnackBar(
    duration: const Duration(milliseconds: 2000),
    padding: const EdgeInsets.symmetric(horizontal: 30),
    backgroundColor: (typeMessage) ? const Color(0xFF323232) : Colors.red[300],
    content: SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(child: dosisText(texto, size: 20, color: Colors.white, maxLines: 3, fontWeight: FontWeight.bold)),
          (typeMessage) ? Icon(icon, color: color) : const Icon(Icons.error_outline)
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void actionsSnackBar(BuildContext context, String texto, String label, void Function() onPressed) {
  final snackBar = SnackBar(
    margin: const EdgeInsets.all(30),
    behavior: SnackBarBehavior.floating,
    duration: const Duration(milliseconds: 6000),
    content: Flexible(child: dosisText(texto, size: 18, color: Colors.white, maxLines: 2)),
    action: SnackBarAction(label: label, onPressed: onPressed),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
