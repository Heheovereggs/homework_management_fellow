import 'package:flutter/cupertino.dart';
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
    var _controller = CupertinoTabController();

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.format_list_numbered_rounded), label: "Public task"),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_numbered_rtl_rounded), label: "Private task"),
        ],
        onTap: (int index) {
          _controller.index = index;
          print(_controller.index);
        },
      ),
      backgroundColor: Colors.white,
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: Icon(Icons.filter_alt),
            middle: Text("HMF"),
            trailing: Icon(Icons.add_rounded),
          ),
          child: ListView.builder(
            itemCount: homeworkList.length,
            itemBuilder: (BuildContext context, int index) {
              return HomeworkCard(homeworkList[index]);
            },
          ),
        );
      },
    );
  }
}
