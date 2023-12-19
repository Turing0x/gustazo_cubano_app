import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ValueNotifier<bool> authStatus = ValueNotifier<bool>(false);
ValueNotifier<bool> reloadProducts = ValueNotifier<bool>(false);

final btnManagerR = StateProvider<bool>((ref) => false);