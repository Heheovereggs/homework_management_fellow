import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSStyleButton extends StatelessWidget {
  final Function buttonOnPress;
  final String displayText;
  final Color buttonColor;
  final Color textColor;
  final EdgeInsets paddingValue;

  IOSStyleButton(
      {this.buttonOnPress,
      this.displayText,
      this.buttonColor = const Color(0xFF2196f3),
      this.textColor = Colors.black,
      this.paddingValue = const EdgeInsets.fromLTRB(8, 4, 8, 8)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Padding(
        padding: paddingValue,
        child: CupertinoButton(
          padding: EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(10.0),
          color: buttonColor,
          child: Text(
            displayText,
            style: Theme.of(context).textTheme.bodyText1.copyWith(color: textColor),
          ),
          onPressed: buttonOnPress,
        ),
      ),
    );
  }
}
