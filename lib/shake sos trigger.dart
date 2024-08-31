import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_sms/flutter_sms.dart';

class SOSShakeDetector extends StatefulWidget {
  @override
  _SOSShakeDetectorState createState() => _SOSShakeDetectorState();
}

class _SOSShakeDetectorState extends State<SOSShakeDetector> {
  double _accelerometerX = 0.0;
  double _accelerometerY = 0.0;
  double _accelerometerZ = 0.0;

  final double _shakeThreshold = 15.0;
  DateTime _lastShakeTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometerX = event.x;
        _accelerometerY = event.y;
        _accelerometerZ = event.z;

        if (_isShakeDetected()) {
          _onShakeDetected();
        }
      });
    });
  }

  bool _isShakeDetected() {
    double acceleration =
        sqrt(_accelerometerX * _accelerometerX +
            _accelerometerY * _accelerometerY +
            _accelerometerZ * _accelerometerZ) -
        9.8; // Subtracting gravity

    if (acceleration > _shakeThreshold) {
      // Check if enough time has passed since the last shake to avoid multiple triggers
      if (DateTime.now().difference(_lastShakeTime) > Duration(seconds: 2)) {
        _lastShakeTime = DateTime.now();
        return true;
      }
    }
    return false;
  }

  void _onShakeDetected() {
    // Trigger the SOS action here
    _sendSOSMessage();
  }

  void _sendSOSMessage() async {
    String message = "SOS! I need help. This is my location: [Location]";
    List<String> recipients = ["+1234567890"]; // Add recipient numbers here

    try {
      String result = await sendSMS(
        message: message,
        recipients: recipients,
        sendDirect: true,
      );
      print(result);
    } catch (error) {
      print("Failed to send SOS message: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shake to Trigger SOS')),
      body: Center(child: Text('Shake the phone to send an SOS message')),
    );
  }
}
