import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IOSStyleButton extends StatelessWidget {
  final Function buttonOnPress;
  final String primaryText;
  final String secondaryText;
  final Color buttonColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final EdgeInsets paddingValue;

  IOSStyleButton(
      {this.buttonOnPress,
      this.primaryText,
      this.secondaryText,
      this.buttonColor = const Color(0xFF2196f3),
      this.primaryTextColor = Colors.black,
      this.secondaryTextColor,
      this.paddingValue = const EdgeInsets.all(8)});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 64,
      child: Padding(
        padding: paddingValue,
        child: CupertinoButton(
          padding: paddingValue,
          borderRadius: BorderRadius.circular(10.0),
          color: buttonColor,
          child: RichText(
            text: TextSpan(
              text: primaryText,
              style: Theme.of(context).textTheme.bodyText2.copyWith(color: primaryTextColor),
              children: <TextSpan>[
                TextSpan(
                  text: secondaryText,
                  style: Theme.of(context).textTheme.bodyText1.copyWith(color: secondaryTextColor),
                )
              ],
            ),
          ),
          onPressed: buttonOnPress,
        ),
      ),
    );
  }
}

class ConfirmButton extends StatelessWidget {
  ConfirmButton({@required this.context, @required this.onPress}) : super();

  final BuildContext context;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: CupertinoButton(
        borderRadius: BorderRadius.circular(10.0),
        color: Color(0xFF2196f3),
        child: Text(
          'OK',
          style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
        ),
        onPressed: onPress,
      ),
    );
  }
}
