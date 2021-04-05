import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import 'buttons.dart';

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

class NoticeDialog {
  final BuildContext context;

  NoticeDialog(this.context);

  void showNoticeDialog(
      {String title, @required String bodyText, bool incomplete = false, bool isExtended = false}) {
    if (incomplete) {
      Vibration.vibrate(duration: 1000);
    }
    List<Widget> displayWidgetsList = [];
    displayWidgetsList.add(SizedBox(height: 25));
    if (title != null) {
      displayWidgetsList.add(Text(title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold)));
      displayWidgetsList.add(SizedBox(height: 15));
    }
    if (bodyText == null) {
    } else {
      displayWidgetsList.add(Text(bodyText,
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.25)));
    }
    displayWidgetsList.add(
      IOSStyleButton(
        primaryText: 'Dismiss',
        primaryTextColor: Color(0xFF2196f3),
        buttonColor: null,
        buttonOnPress: () {
          Navigator.of(context).pop();
        },
      ),
    );

    showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            width: 300,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: displayWidgetsList,
              ),
            ),
          )
        ],
      ),
    );
  }
}
