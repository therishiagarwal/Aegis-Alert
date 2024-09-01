import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart'; // Import the shake package

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLocationEnabled = false;
  bool _isMicrophoneEnabled = false;
  bool _isSOSEnabled = false;
  ShakeDetector? _shakeDetector;

  @override
  void initState() {
    super.initState();
    // Initialize the shake detector with custom sensitivity
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _handleShake,
      shakeThresholdGravity: 9, // Adjust this value as needed for sensitivity
    );  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        _isLocationEnabled = true;
      });
    } else {
      setState(() {
        _isLocationEnabled = false;
      });
    }
  }

  Future<void> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        _isMicrophoneEnabled = true;
      });
    } else {
      setState(() {
        _isMicrophoneEnabled = false;
      });
    }
  }

  Future<void> _requestSOSPermission() async {
    PermissionStatus phoneStatus = await Permission.phone.request();
    PermissionStatus locationStatus = await Permission.locationAlways.request();
    PermissionStatus smsStatus = await Permission.sms.request();

    if (phoneStatus.isGranted && locationStatus.isGranted && smsStatus.isGranted) {
      setState(() {
        _isSOSEnabled = true;
      });
    } else {
      setState(() {
        _isSOSEnabled = false;
      });
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text('To enable SOS, all required permissions (Phone, Location, SMS) must be granted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Handle shake gesture
  void _handleShake() {
    if (_isSOSEnabled) {
      // Trigger SOS action
      _triggerSOS();
    }
  }

  // Example SOS action
  void _triggerSOS() {
    // Implement SOS action here
    // You can send an SMS, make a call, or any other SOS action you intend to perform
    print("SOS Triggered!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchListTile(
            title: Text('Enable Location'),
            value: _isLocationEnabled,
            onChanged: (bool value) async {
              if (!_isLocationEnabled) {
                await _requestLocationPermission();
              } else {
                setState(() {
                  _isLocationEnabled = value;
                });
              }
            },
          ),
          SwitchListTile(
            title: Text('Enable Microphone'),
            value: _isMicrophoneEnabled,
            onChanged: (bool value) async {
              if (!_isMicrophoneEnabled) {
                await _requestMicrophonePermission();
              } else {
                setState(() {
                  _isMicrophoneEnabled = value;
                });
              }
            },
          ),
          SwitchListTile(
            title: Text('Enable SOS'),
            value: _isSOSEnabled,
            onChanged: (bool value) async {
              if (!_isSOSEnabled) {
                await _requestSOSPermission();
              } else {
                setState(() {
                  _isSOSEnabled = value;
                });
              }
            },
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _triggerSOS(); // Manually trigger SOS action
                },
                child: Text('SOS'),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 100),
                  shape: RoundedRectangleBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Implement Trigger Alert action
                },
                child: Text('Trigger Alert'),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(100, 100),
                  shape: RoundedRectangleBorder(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
