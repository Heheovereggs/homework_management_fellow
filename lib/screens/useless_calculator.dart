import 'package:flutter/material.dart';
import 'package:homework_management_fellow/widgets/boxed_text_note.dart';
import 'package:homework_management_fellow/widgets/buttons.dart';

class UselessCalculator extends StatefulWidget {
  @override
  _UselessCalculatorState createState() => _UselessCalculatorState();
}

class _UselessCalculatorState extends State<UselessCalculator> {
  TextEditingController _heightController;
  final _formKey = GlobalKey<FormState>();

  void _heightOnSubmit() {
    if (!_formKey.currentState.validate()) {
      return null;
    }
    NoticeDialog(context).showNoticeDialog(
        title: "Height Calculator", bodyText: "Your height is ${_heightController.text.trim()} cm");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Height calculator"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: TextFormField(
              controller: _heightController,
              autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                hintText: "Enter your height in cm",
                errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                errorStyle: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red),
              ),
              validator: (String value) {
                value = _heightController.text.trim();
                if (value.isEmpty) {
                  return "Your data is required";
                }
                return double.tryParse(value) != null ? null : 'Please only enter numbers';
              },
              textInputAction: TextInputAction.done,
            ),
          ),
          Image.asset('images/huaji.jpg'),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: IOSStyleButton(
                buttonOnPress: _heightOnSubmit,
                buttonColor: Colors.pinkAccent,
                primaryText: "Calculate",
                primaryTextColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
