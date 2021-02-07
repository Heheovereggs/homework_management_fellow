import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class TaskCreatePage extends StatelessWidget {
  static const String id = 'TaskCreatePage';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      color: Color.fromRGBO(117, 117, 117, 1),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(35.0),
              child: Text("cast"),
            ),
            Padding(
              padding: EdgeInsets.all(35.0),
              child: Text("apply for cast"),
            ),
            Padding(
              padding: EdgeInsets.all(35.0),
              child: Text("private"),
            ),
          ],
        ),
      ),
    );
  }
}
