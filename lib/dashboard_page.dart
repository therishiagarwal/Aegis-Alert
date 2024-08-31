import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isLocationEnabled = false;
  bool isMicrophoneEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Location Toggle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Location Access'),
                Switch(
                  value: isLocationEnabled,
                  onChanged: (value) {
                    setState(() {
                      isLocationEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Microphone Toggle Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Microphone Access'),
                Switch(
                  value: isMicrophoneEnabled,
                  onChanged: (value) {
                    setState(() {
                      isMicrophoneEnabled = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 50),
            // Square Buttons
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement SOS functionality
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 100), // Square size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('SOS'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement Trigger Alert functionality
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(100, 100), // Square size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Trigger Alert'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
