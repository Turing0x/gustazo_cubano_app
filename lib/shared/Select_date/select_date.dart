import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/config/riverpod/declarations.dart';
import 'package:gustazo_cubano_app/shared/widgets.dart';
import 'package:intl/intl.dart';

class CustomDateSelect extends ConsumerStatefulWidget {
  const CustomDateSelect({super.key, this.showDate = true});

  final bool showDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomDateSelectState();
}

class _CustomDateSelectState extends ConsumerState<CustomDateSelect> {
  @override
  Widget build(BuildContext context) {
    final janddate = ref.watch(janddateR);
    final janddateM = ref.read(janddateR.notifier);
    return Column(
      children: [
        Visibility(
          visible: widget.showDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                dosisText('Fecha', size: 22, fontWeight: FontWeight.bold),
                Flexible(
                  child: Container(
                      height: 40,
                      width: 150,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10)),
                      child: dosisText(janddate.currentDate, size: 20, fontWeight: FontWeight.bold)),
                ),
                Flexible(
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Colors.black38,
                        )
                      ),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(DateTime.now().year),
                            lastDate: DateTime(DateTime.now().year + 1));

                        if (pickedDate != null) {
                          String formattedDate =
                              DateFormat.MMMd('en').format(pickedDate);
                          janddateM.setCurrentDate(formattedDate);
                        }
                      },
                      child: dosisText('Cambiar', size: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
