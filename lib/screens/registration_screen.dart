import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:homework_management_fellow/model/student.dart';
import 'package:homework_management_fellow/screens/section_select_screen.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/widgets/boxed_text_note.dart';
import 'package:homework_management_fellow/widgets/buttons.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String uid;
  late String email;
  final _formKey = GlobalKey<FormState>();
  final _firstController = TextEditingController();
  final _lastController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    email = arguments['email'];
    uid = arguments['uid'];
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Registration"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(
                      "Your email: $email",
                      style: TextStyle(fontSize: 24, height: 1.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: registrationTextFormField("First name", _firstController),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: registrationTextFormField("Last name", _lastController),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CupertinoSlidingSegmentedControl(
                  //     thumbColor: Color(0xFF2196f3),
                  //     groupValue: isDiscord,
                  //     onValueChanged: (dynamic value) {
                  //       setState(() {
                  //         isDiscord = value;
                  //       });
                  //     },
                  //     children: <bool, Widget>{
                  //       true: Text("Yes"),
                  //       false: Text("No"),
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: 15,
                  ),
                  ExplanationText("No password required since Goooooooooooooogle will do the verification"),
                  IOSStyleButton(primaryText: "Next step", buttonOnPress: _saveInfoForm),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField registrationTextFormField(final String hint, TextEditingController textEditingController) {
    return TextFormField(
      controller: textEditingController,
      autocorrect: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
        hintText: hint,
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        errorStyle: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.red),
      ),
      validator: (String? value) {
        value = textEditingController.text.trim();
        if (value.isEmpty) {
          return "$hint is required";
        }
        final validCharacters = RegExp(r'^[a-z\-àâçéèêëîïôûùüÿñæœ\s]+$', caseSensitive: false);
        return validCharacters.hasMatch(value) ? null : 'Please only enter letter and "-"';
      },
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.words,
    );
  }

  void _saveInfoForm() {
    if (!_formKey.currentState!.validate()) {
      return null;
    }
    Student student = Student(
      uid: uid,
      email: email,
      firstName: _firstController.text.trim(),
      lastName: _lastController.text.trim(),
      admin: false,
      activate: false,
      dateOfJoin: DateTime.now(),
      theme: null,
      ban: false,
    );

    // save to provider StateService
    Provider.of<DataService>(context, listen: false).setStudent(student);

    // save to firebase
    FirebaseService firebaseService = FirebaseService();
    firebaseService.saveLoginInfo(student);

    Navigator.pushReplacementNamed(context, SectionSelectScreen.id);
  }
}
