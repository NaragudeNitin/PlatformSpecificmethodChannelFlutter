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
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod("getBatteryLevel");
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: ElevatedButton(
                  onPressed: _getBatteryLevel,
                  child: const Text(
                      textDirection: TextDirection.ltr, 'Get Battery Level'),
                ),
              ),
              Text(_batteryLevel, textDirection: TextDirection.ltr),
            ],
          ),
        ),
      ),
    );
  }
}
