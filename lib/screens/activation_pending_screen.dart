import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivationPendingScreen extends StatelessWidget {
  static const String id = 'ActivationPendingScreen';
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Colors.orangeAccent, Colors.pinkAccent]);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Activation pending",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              foreground: Paint()..shader = shader,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            "PLease check later or press the button to refresh status",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              foreground: Paint()..shader = shader,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(19),
            child: SizedBox(
              width: 350,
              child: CupertinoButton(
                borderRadius: BorderRadius.circular(30.0),
                color: Color(0xFF2196f3),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  //TODO: check activate from cloud
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
