import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

const methodChannel = MethodChannel('com.example.iosenginecrash/crash');

void backgroundEngineMain() {
  print('Hello World!');
}

Future<void> performMethodCall() async {
  final CallbackHandle handle =
      PluginUtilities.getCallbackHandle(backgroundEngineMain);

  return await methodChannel.invokeMethod('', [handle.toRawHandle()]);
}

Future<void> asyncGap() async {
  // Doing some async work to setup for the bug
  await SharedPreferences.getInstance();

  // Calling the method channel to setup the background engine, will cause
  // a native crash on iOS.  Awaiting this method will prevent the crash.
  performMethodCall();
}

Future<void> main() async {
  await runZoned(() async {
    await asyncGap();

    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(),
    );
  }
}
