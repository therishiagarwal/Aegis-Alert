import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLocationEnabled = false;
  bool isMicrophoneEnabled = false;

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {
        isLocationEnabled = true;
      });
    } else {
      setState(() {
        isLocationEnabled = false;
      });
      // Handle permission denial
    }
  }

  Future<void> requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        isMicrophoneEnabled = true;
      });
    } else {
      setState(() {
        isMicrophoneEnabled = false;
      });
      // Handle permission denial
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Location Access'),
                    Switch(
                      value: isLocationEnabled,
                      onChanged: (value) {
                        if (value) {
                          requestLocationPermission();
                        } else {
                          setState(() {
                            isLocationEnabled = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Microphone Access'),
                    Switch(
                      value: isMicrophoneEnabled,
                      onChanged: (value) {
                        if (value) {
                          requestMicrophonePermission();
                        } else {
                          setState(() {
                            isMicrophoneEnabled = false;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement SOS functionality
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    minimumSize: Size(100, 100),
                  ),
                  child: Text('SOS'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement trigger alert functionality
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    minimumSize: Size(100, 100),
                  ),
                  child: Text('Trigger Alert'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
