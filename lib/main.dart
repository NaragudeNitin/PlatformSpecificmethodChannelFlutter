import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel("samples.flutter.dev/battery");

  // Get battery using value notifier we are declaring it here.
  final ValueNotifier<String> _batteryLevelNotifier =
      ValueNotifier<String>('Unknown battery level.');
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Starts the periodic timer to update the battery level every seconds.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getBatteryLevel();
    });
  }

  @override
  void dispose() {
    //disposing the timer and battery notifier after every call
    _batteryLevelNotifier.dispose();
    _timer.cancel();
    super.dispose();
  }

  // this os the method to call battery percentage according to platform
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod("getBatteryLevel");
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    _batteryLevelNotifier.value = batteryLevel;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ValueListenableBuilder<String>(
                  valueListenable: _batteryLevelNotifier,
                  builder: (context, batteryLevel, child) {
                    return Text(batteryLevel, textDirection: TextDirection.ltr);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
