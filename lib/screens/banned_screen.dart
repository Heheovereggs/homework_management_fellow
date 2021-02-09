import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BannedScreen extends StatelessWidget {
  static const String id = 'BannedScreen';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Gradient gradient = LinearGradient(colors: [Colors.orangeAccent, Colors.pinkAccent]);
    Shader shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    _launchURL() async {
      const url = 'https://discord.com/channels/747561660193046582/786369055987990558/808446122334879765';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You has be banned",
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
              "fles ruoy kcuf og esaelp owN",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                foreground: Paint()..shader = shader,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "or you can go to CET server for a reason",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                foreground: Paint()..shader = shader,
              ),
            ),
            SizedBox(
              height: 19,
            ),
            Icon(Icons.arrow_downward, color: Color(0xFFff7660), size: 50),
            GestureDetector(onTap: _launchURL, child: Image(image: AssetImage("images/discord_blender.png"), height: 100.0)),
          ],
        ),
      ),
    );
  }
}
