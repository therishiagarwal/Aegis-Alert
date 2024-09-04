import 'package:flutter/material.dart';

class GovtVerifiedSignupPage extends StatelessWidget {
  const GovtVerifiedSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Govt. Verified Signup'),
      ),
      body: const Center(
        child: Text('Signup with your Govt. Verified ID.'),
      ),
    );
  }
}
