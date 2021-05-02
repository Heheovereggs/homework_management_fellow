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
      {String title, @required String bodyText, bool isVibrate = false, double windowWidth = 300.0}) {
    if (isVibrate) {
      Vibration.vibrate(pattern: [0, 300, 200, 500]);
    }
    List<Widget> displayWidgetsList = [];
    displayWidgetsList.add(SizedBox(height: 25));
    if (title != null) {
      displayWidgetsList.add(Text(title,
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.caption.copyWith(fontSize: 20)));
      displayWidgetsList.add(SizedBox(height: 15));
    }
    if (bodyText == null) {
    } else {
      displayWidgetsList.add(Text(bodyText,
          textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2.copyWith(height: 1.25)));
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
            width: windowWidth,
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

class UserSeeOnlyNotification extends StatefulWidget {
  final bool visible;
  final String text;
  UserSeeOnlyNotification({this.visible, this.text});

  @override
  _UserSeeOnlyNotificationState createState() => _UserSeeOnlyNotificationState();
}

class _UserSeeOnlyNotificationState extends State<UserSeeOnlyNotification> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedOpacity(
        opacity: widget.visible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Padding(
          padding: EdgeInsets.only(bottom: 80.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 45,
                decoration:
                    BoxDecoration(color: Color(0xCC000000), borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    widget.text,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
