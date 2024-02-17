import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

String todayGlobal = DateFormat.MMMd('en').format(DateTime.now());

class JAndDateProvider extends StateNotifier<JAndDateModel> {
  JAndDateProvider() : super(JAndDateModel(currentDate: todayGlobal));

  void setCurrentDate(String date) {
    state = state.copyWith(currentDate: date);
  }
}

class JAndDateModel {
  final String currentDate;

  JAndDateModel({
    required this.currentDate,
  });

  copyWith({
    String? currentDate,
  }) {
    return JAndDateModel(
      currentDate: currentDate ?? this.currentDate,
    );
  }
}
