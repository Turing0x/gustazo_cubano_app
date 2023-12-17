import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

ListTile optListTile(IconData leading, String title, String subtitle,
    Function()? onTap, bool flecha,
    {Color? color = Colors.transparent}) {
  return ListTile(
    trailing: (flecha)
        ? const Icon(Icons.arrow_right_rounded)
        : null,
    subtitle: dosisText(subtitle),
    leading: Icon(
      leading,
    ),
    title: dosisText(title, fontWeight: FontWeight.bold),
    tileColor: color,
    minLeadingWidth: 20,
    onTap: onTap,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  );
}