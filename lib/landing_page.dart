import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text('Signup'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement the navigation to the Government Verified ID signup page
                    },
                    child: const Text('Signup with Govt. Verified ID'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0), // Optional padding
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text('Go to Dashboard'),
            ),
          ),
        ],
      ),
    );
  }
}
