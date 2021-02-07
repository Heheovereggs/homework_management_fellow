import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/screens/setting_screen.dart';
import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:homework_management_fellow/main.dart';
import 'package:homework_management_fellow/widgets/task_create_page.dart';
import 'package:provider/provider.dart';

class TaskList extends StatelessWidget {
  TaskList(this.homeworkList);
  final List<Homework> homeworkList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushNamed(context, SettingScreen.id);
          },
          child: Icon(Icons.settings),
        ),
        title: Text("HMF"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              //TODO: add task filter page
            },
          ),
          SizedBox(width: 8)
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView.builder(
          itemCount: homeworkList.length,
          itemBuilder: (BuildContext context, int index) {
            return HomeworkCard(homeworkList[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          Navigator.pushNamed(context, TaskCreatePage.id);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 75,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                iconSize: 30.0,
                icon: Icon(Icons.format_list_numbered_rounded),
                onPressed: () {
                  // switch to next screen
                },
              ),
              IconButton(
                iconSize: 30.0,
                icon: Icon(Icons.format_list_numbered_rtl_rounded),
                onPressed: () {
                  // switch to next screen
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
