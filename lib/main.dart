import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
      // Set the text direction here (TextDirection.ltr or TextDirection.rtl)
      // based on your app's requirements.
      // For example, if your app uses left-to-right (LTR) text direction:
      // textDirection: TextDirection.ltr,
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

  // Get battery level.
  final ValueNotifier<String> _batteryLevelNotifier =
      ValueNotifier<String>('Unknown battery level.');
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start the periodic timer to update the battery level every 5 seconds.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getBatteryLevel();
    });
  }

  @override
  void dispose() {
    _batteryLevelNotifier.dispose();
    _timer.cancel();
    super.dispose();
  }

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
