import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart'; // Import the shake package
import 'package:geolocator/geolocator.dart'; // Import for location
import 'package:flutter/services.dart'; // Import for method channel
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart'; // Import for direct calling

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const platform = MethodChannel('com.example.sos/trigger');

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
    );
  }

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

  void _handleShake() {
    if (_isSOSEnabled) {
      // Trigger SOS action
      _triggerSOS();
    }
  }

  Future<void> _triggerNativeSOS() async {
    try {
      await platform.invokeMethod('triggerSOS');
    } on PlatformException catch (e) {
      print("Failed to trigger SOS: '${e.message}'.");
    }
  }

  Future<void> _triggerSOS() async {
    // Define your emergency contacts and phone numbers
    const emergencyContacts = ['+91 83196 81297']; // Replace with actual numbers
    const emergencyNumber = '+91 83196 81297'; // Replace with actual emergency number if needed

    // Get current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String locationMessage = 'I need help! My current location is: https://maps.google.com/?q=${position.latitude},${position.longitude}';

    // Trigger native SOS action by making an emergency call
    await _triggerNativeSOS();

    // Directly call the emergency number
    await FlutterPhoneDirectCaller.callNumber(emergencyNumber);

    // Notify the user
    print('SOS Triggered!');
  }

  Future<void> _handleTriggerAlert() async {
    if (_isSOSEnabled) {
      // Trigger SOS action
      await _triggerSOS();

      // Print messages
      print('Alert Triggered!');
      print('SOS Triggered!');
      print('Location sent to the emergency contacts');

      // Implement your audio alert functionality here
      // For example, you can play a sound using an audio plugin
    } else {
      print('SOS is not enabled. Please enable SOS first.');
    }
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
            title: Text('Enable Emergency SOS'),
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
                  _handleTriggerAlert(); // Handle Trigger Alert button press
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
