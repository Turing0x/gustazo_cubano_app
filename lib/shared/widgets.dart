import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Text dosisText(String text, {
  double size = 18, 
  Color color = Colors.black,
  int maxLines = 1,
  FontWeight fontWeight = FontWeight.normal,
  TextAlign textAlign = TextAlign.left
}) {
  return Text(
    text,
    maxLines: maxLines,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: size,
      fontFamily: 'Dosis',
      color: color,
      fontWeight: fontWeight
    ),
  );
}

void showToast(String msg, {bool type = false}) => Fluttertoast.showToast(
  backgroundColor: type ? Colors.green[400] : Colors.red[400],
  msg: msg,
  toastLength: Toast.LENGTH_LONG,
);

PreferredSizeWidget? showAppBar(String titulo,
    {
      Widget? leading, 
      List<Widget>? actions, 
      bool centerTitle = true,
      Color backgroundColor = const Color.fromARGB(255, 147, 128, 228)
    }) {
  return AppBar(
    title: dosisText(titulo, size: 24, color: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: backgroundColor,
    elevation: 5,
    centerTitle: centerTitle,
    leading: leading,
    actions: actions,
  );
}

Widget dosisBold(String texto, String another, double? fontSize,
    {Color? color = Colors.black}) {
  return RichText(
    text: TextSpan(
      // Here is the explicit parent TextStyle
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.black,
        fontFamily: 'Dosis',
      ),
      children: <TextSpan>[
        TextSpan(
            text: texto, style: const TextStyle(fontWeight: FontWeight.bold)),
        TextSpan(text: another),
      ],
    ),
  );
}