import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExplanationText extends StatelessWidget {
  final String displayText;

  ExplanationText(this.displayText);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              displayText,
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
