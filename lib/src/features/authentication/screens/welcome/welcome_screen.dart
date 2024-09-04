import 'package:flutter/material.dart';

import '../../../../constants/text_strinigs.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
              children: [
                // Image(image: AssetImage(),)
                const Text(tWelcomeTitle),
                const Text(tWelcomeSubTitle),
                Row(
                  children: [
                    OutlinedButton(onPressed: (){}, child: const Text(tLogin)),
                    ElevatedButton(onPressed: (){}, child: const Text(tSignup)),
                  ],
                )
              ]
          ),
        )
    );
  }
}
