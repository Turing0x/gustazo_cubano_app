import 'package:flutter/material.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';

class CommonDismissible extends StatelessWidget {
  const CommonDismissible(
      {super.key,
      required this.valueKey,
      required this.text,
      required this.child,
      required this.onDismissed,
      required this.canDissmis});

  final String valueKey;
  final String text;
  final bool canDissmis;
  final Widget child;
  final void Function(DismissDirection)? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(valueKey),
      background: backgroundContainer(),
      direction: (canDissmis) ? DismissDirection.endToStart : DismissDirection.none,
      onDismissed: onDismissed,
      child: child,
    );
  }

  Container backgroundContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          dosisText(text, size: 18, fontWeight: FontWeight.w600, color: Colors.white),
          const Icon(Icons.delete_forever_outlined, color: Colors.white)
        ],
      ),
    );
  }
}
