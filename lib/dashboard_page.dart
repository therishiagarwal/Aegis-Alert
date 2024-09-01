// dasboard_page.dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLocationEnabled = false;
  bool _isMicrophoneEnabled = false;
  bool _isSOSEnabled = false;

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
    // Request phone permission as an example, assuming it's necessary for the SOS feature.
    PermissionStatus phoneStatus = await Permission.phone.request();
    PermissionStatus locationStatus = await Permission.location.request();
    PermissionStatus smsStatus = await Permission.sms.request(); // Example: Requesting SMS permission for sending SOS messages.

    if (phoneStatus.isGranted && locationStatus.isGranted && smsStatus.isGranted) {
      setState(() {
        _isSOSEnabled = true;
      });
    } else {
      // If any permission is denied, set SOS as disabled and show a dialog or notification.
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
                  // Implement SOS action
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
