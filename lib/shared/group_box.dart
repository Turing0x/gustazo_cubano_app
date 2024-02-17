import 'package:flutter/material.dart';

Container customGroupBox(String labelText, List<Widget> widgets) {
  return Container(
    padding: const EdgeInsets.only(top: 30),
    margin: const EdgeInsets.only(bottom: 10),
    child: InputDecorator(
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: const EdgeInsets.all(25)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: widgets),
    ),
  );
}
