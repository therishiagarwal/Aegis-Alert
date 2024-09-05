import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:background_sms/background_sms.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:first_app/landing_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  static const platform = MethodChannel('com.example.sos/trigger');

  bool _isLocationEnabled = false;
  bool _isMicrophoneEnabled = false;
  bool _isSOSEnabled = false;
  ShakeDetector? _shakeDetector;
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();

    _requestAllPermissions();

    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _handleShake,
      shakeThresholdGravity: 8,
    );
  }

  Future<void> _requestAllPermissions() async {
    await _requestLocationPermission();
    await _requestMicrophonePermission();
    await _requestSOSPermission();
  }

  Future<void> _openAppSettings() async {
    bool opened = await openAppSettings();
    if (!opened) {
      print('Failed to open app settings.');
    }
  }

  @override
  void dispose() {
    _shakeDetector?.stopListening();
    super.dispose();
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.locationAlways.request();
    if (status.isGranted) {
      setState(() {
        _isLocationEnabled = true;
      });
    } else {
      setState(() {
        _isLocationEnabled = false;
      });
      _showPermissionDeniedDialog();
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
        title: const Text('Permission Required'),
        content: const Text('You need to grant location always and other permissions for full functionality.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openAppSettings();  // Open app settings when "OK" is clicked
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }


  void _handleShake() {
    if (_isSOSEnabled) {
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
    const emergencyNumber = '+91 83196 81297';  // Replace with your emergency number

    try {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      String locationMessage = 'I need help! My current location is: https://maps.google.com/?q=${position.latitude},${position.longitude}';

      // Check if a contact has been selected
      if (_selectedContact != null) {
        String? phoneNumber = _selectedContact?.phones?.isNotEmpty == true
            ? _selectedContact?.phones?.first.value
            : null;

        if (phoneNumber != null) {
          SmsStatus status = await BackgroundSms.sendMessage(
            phoneNumber: phoneNumber,
            message: 'I am in trouble. $locationMessage',
          );
          if (status == SmsStatus.sent) {
            print('SOS message sent to $phoneNumber');
          } else {
            print('Failed to send SOS message to $phoneNumber');
          }
        } else {
          print('Selected contact has no phone number.');
        }
      } else {
        // Send SMS to the emergency number if no contact is selected
        SmsStatus status = await BackgroundSms.sendMessage(
          phoneNumber: emergencyNumber,
          message: 'I am in trouble. $locationMessage',
        );
        if (status == SmsStatus.sent) {
          print('SOS message sent to emergency number: $emergencyNumber');
        } else {
          print('Failed to send SOS message to emergency number: $emergencyNumber');
        }
      }

      // Call emergency number
      await FlutterPhoneDirectCaller.callNumber(emergencyNumber);
      print('SOS Triggered!');
    } catch (e) {
      print('An error occurred while triggering SOS: $e');
    }
  }


  Future<void> _handleTriggerAlert() async {
    if (_isSOSEnabled) {
      await _triggerSOS();
      print('Alert Triggered!');
      print('SOS Triggered!');
      print('Location sent to the emergency contacts');
    } else {
      print('SOS is not enabled. Please enable SOS first.');
    }
  }

  Future<void> _pickContact() async {
    PermissionStatus permission = await Permission.contacts.request();

    if (permission.isGranted) {
      List<Contact> contacts = await ContactsService.getContacts();
      Contact? contact = await showDialog<Contact>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select Contact'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                Contact contact = contacts[index];
                return ListTile(
                  title: Text(contact.displayName ?? ''),
                  onTap: () {
                    Navigator.of(context).pop(contact);
                  },
                );
              },
            ),
          ),
        ),
      );

      if (contact != null) {
        setState(() {
          _selectedContact = contact;
        });

        String? phoneNumber = contact.phones?.isNotEmpty == true
            ? contact.phones!.first.value
            : null;

        if (phoneNumber != null) {
          print("Selected contact number: $phoneNumber");
        } else {
          print("Selected contact has no phone number.");
        }
      }
    } else {
      print("Contacts permission denied.");
    }
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer when hamburger menu is clicked
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Manage Emergency Contacts'),
              onTap: () {
                _pickContact(); // Open contact picker
                Navigator.of(context).pop(); // Close the drawer after selecting
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout, // Log out when this option is selected
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchListTile(
            title: const Text('Enable Location Track'),
            value: _isLocationEnabled,
            onChanged: (bool value) async {
              if (!value) {
                setState(() {
                  _isLocationEnabled = value;
                });
              } else {
                await _requestLocationPermission();
              }
            },
          ),
          SwitchListTile(
            title: const Text('Enable Microphone Track'),
            value: _isMicrophoneEnabled,
            onChanged: (bool value) async {
              if (!value) {
                setState(() {
                  _isMicrophoneEnabled = value;
                });
              } else {
                await _requestMicrophonePermission();
              }
            },
          ),
          SwitchListTile(
            title: const Text('Enable Emergency SOS'),
            value: _isSOSEnabled,
            onChanged: (bool value) async {
              if (!value) {
                setState(() {
                  _isSOSEnabled = value;
                });
              } else {
                await _requestSOSPermission();
              }
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _handleTriggerAlert();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Trigger SOS'),
              ),
              ElevatedButton(
                onPressed: () {
                  _handleTriggerAlert();
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(150, 100),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Trigger Alert'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
