import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/screens/setting_screen.dart';
import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:homework_management_fellow/main.dart';
import 'package:homework_management_fellow/widgets/task_create_page.dart';

class TaskList extends StatelessWidget {
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
          print(index);
        },
      ),
      tabBuilder: (context, index) {
        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: Icon(Icons.filter_alt),
            middle: Text("HMF"),
            trailing: Icon(Icons.add_rounded),
          ),
          child: ListView(
            children: [
              HomeworkCard(name: "101", dueDate: "1212", subject: "123"),
            ],
          ),
        );
      },
    );
  }
}
