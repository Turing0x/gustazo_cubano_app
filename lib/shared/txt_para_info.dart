import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class TxtInfo extends StatefulWidget {
  final TextEditingController controlador;
  final TextInputType keyboardType;
  final Function(String?) onChange;
  final Color? color;
  final IconData? icon;
  final String texto;
  final double left;
  final bool readOnly;
  final bool showCursor;
  final double right;
  final double top;
  final List<TextInputFormatter>? inputFormatters;

  const TxtInfo({
    super.key,
    required this.keyboardType,
    required this.controlador,
    required this.onChange,
    required this.color,
    required this.texto,
    this.icon,
    this.left = 30,
    this.readOnly = false,
    this.showCursor = true,
    this.right = 30,
    this.top = 10,
    this.inputFormatters,
  });

  @override
  State<TxtInfo> createState() => _TxtInfoState();
}

class _TxtInfoState extends State<TxtInfo> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: widget.left, right: widget.right, top: widget.top),
      child: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
            color: widget.color, borderRadius: BorderRadius.circular(10)),
            child: TextField(
              showCursor: widget.showCursor,
              keyboardType: widget.keyboardType,
              controller: widget.controlador,
              onChanged: widget.onChange,
              readOnly: widget.readOnly,
              style: const TextStyle(fontFamily: 'Dosis', fontSize: 20),
              inputFormatters: widget.inputFormatters,
              decoration: InputDecoration(
                label: dosisText(widget.texto),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                focusedBorder: InputBorder.none,
                counterText: '',
                border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}