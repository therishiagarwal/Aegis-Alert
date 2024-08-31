import 'package:flutter/material.dart';

import '../../../../constants/text_strinigs.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Column(
              children: [
                // Image(image: AssetImage(),)
                Text(tWelcomeTitle),
                Text(tWelcomeSubTitle),
                Row(
                  children: [
                    OutlinedButton(onPressed: (){}, child: Text(tLogin)),
                    ElevatedButton(onPressed: (){}, child: Text(tSignup)),
                  ],
                )
              ]
          ),
        )
    );
  }
}
