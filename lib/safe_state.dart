// lib/utils/safe_state.dart
import 'package:flutter/material.dart';
import '../../main.dart'; // per appNavigatorKey (adatta il path)

mixin SafeState<T extends StatefulWidget> on State<T> {
  void setStateSafe(VoidCallback fn) {
    if (!mounted) return;
    setState(fn);
  }

  bool get isMounted => mounted;

  void showSnackSafe(String text) {
    if (!mounted) return;
    final ctx = appNavigatorKey.currentContext ?? context;
    ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(text)));
  }

  void popSafe() {
    appNavigatorKey.currentState?.maybePop();
  }
}
