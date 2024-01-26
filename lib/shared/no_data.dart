import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

Widget noData(BuildContext context, String text) {
  final size = MediaQuery.of(context).size;

  return Center(
      child: Column(
    children: [
      Container(
        height: size.height * 0.3,
        margin: EdgeInsets.only(
            left: size.width * .07,
            right: size.width * .07,
            bottom: 20),
        child: Image.asset('lib/assets/images/empty_list.jpg'),
      ),

      dosisText(
        text, 
        size: 18, maxLines: 3, textAlign: TextAlign.center),
      
    ],
  ));
}
