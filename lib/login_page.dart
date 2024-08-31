import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  String verificationId = '';

  void loginUser(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: '+91$phoneNumber', // Prefixing with country code
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        navigateToDashboard();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          showError('The provided phone number is not valid.');
        } else {
          showError('Verification failed. Please try again.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  void verifyOTP(String otp) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await auth.signInWithCredential(credential);
      navigateToDashboard();
    } catch (e) {
      showError("Failed to sign in: $e");
    }
  }

  void navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardPage()),
    );
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  bool validatePhoneNumber(String phoneNumber) {
    return phoneNumber.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phoneNumber);
  }

  bool validateOTP(String otp) {
    return otp.length == 6 && RegExp(r'^[0-9]+$').hasMatch(otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String phoneNumber = phoneController.text.trim();
                if (validatePhoneNumber(phoneNumber)) {
                  loginUser(phoneNumber);
                } else {
                  showError('Please enter a valid 10-digit phone number.');
                }
              },
              child: Text('Send OTP'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String otp = otpController.text.trim();
                if (validateOTP(otp)) {
                  verifyOTP(otp);
                } else {
                  showError('Please enter a valid 6-digit OTP.');
                }
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
