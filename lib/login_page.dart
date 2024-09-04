import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  void showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
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
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String phoneNumber = phoneController.text.trim();
                if (validatePhoneNumber(phoneNumber)) {
                  loginUser(phoneNumber);
                } else {
                  showError('Please enter a valid 10-digit phone number.');
                }
              },
              child: const Text('Send OTP'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(labelText: 'Enter OTP'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String otp = otpController.text.trim();
                if (validateOTP(otp)) {
                  verifyOTP(otp);
                } else {
                  showError('Please enter a valid 6-digit OTP.');
                }
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
