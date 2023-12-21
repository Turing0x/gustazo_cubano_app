import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gustazo_cubano_app/shared/Fecha_Jornada/jornal_and_date_bloc.dart';

ValueNotifier<bool> authStatus = ValueNotifier<bool>(false);
ValueNotifier<bool> reloadProducts = ValueNotifier<bool>(false);

final janddateR = StateNotifierProvider<JAndDateProvider, JAndDateModel>(
    (ref) => JAndDateProvider());

final btnManagerR = StateProvider<bool>((ref) => false);