import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/screens/private_task_screen.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:homework_management_fellow/screens/task_create_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Homework> homeworkList = [];
  void initState() {
    super.initState();
    loadHomeworkList();
  }

  void loadHomeworkList() async {
    List studentSectionIds = Provider.of<DataService>(context, listen: false).student.sectionIds;
    List<Homework> _homeworkList =
        await Provider.of<FirebaseService>(context, listen: false).getPublicHomeWorkList(studentSectionIds);
    setState(() {
      homeworkList = _homeworkList;
    });
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async {
    loadHomeworkList();
    _refreshController.refreshCompleted();
  }

  void filterIconOnTap() {
    //TODO: filter page
  }

  void infoIconOnTap() {
    //TODO: info pop up page
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.format_list_numbered_rounded), label: "Public task"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add task"),
            BottomNavigationBarItem(icon: Icon(Icons.local_library_rounded), label: "Private task"),
          ],
        ),
        backgroundColor: Colors.white,
        tabBuilder: (context, index) {
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: Color(0xFF2196f3),
              leading: GestureDetector(
                child: Icon(
                  index == 1 ? Icons.info_outline_rounded : Icons.filter_alt,
                  color: Colors.white,
                ),
                onTap: index == 1 ? infoIconOnTap : filterIconOnTap,
              ),
              middle: Text(
                "HMF",
                style: TextStyle(color: Colors.white),
              ),
              trailing: GestureDetector(
                child: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/SettingScreen');
                },
              ),
            ),
            child: screenChoice(index),
          );
        },
      ),
    );
  }

  Widget screenChoice(int index) {
    if (index == 0) {
      return taskPageBuilder();
    } else if (index == 1) {
      return TaskCreatePage();
    } else {
      return PrivateTaskScreen();
    }
  }

  CupertinoScrollbar taskPageBuilder() {
    return CupertinoScrollbar(
      child: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        enablePullUp: false,
        enablePullDown: true,
        header: ClassicHeader(
          textStyle: Theme.of(context).textTheme.bodyText1,
        ),
        enableTwoLevel: false,
        child: homeworkList.isNotEmpty
            ? ListView.builder(
                itemCount: homeworkList.length,
                itemBuilder: (BuildContext context, int index) {
                  return HomeworkCard(homeworkList[index]);
                },
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("🤔🤔🤔", textAlign: TextAlign.center),
                    Text("Seriously?"),
                    SizedBox(height: 30),
                    Text(
                        "No even a single task has been added by anybody at the moment...\n\n(Pull down to refresh)\n\n(And good luck)",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 20)),
                  ],
                ),
              ),
      ),
    );
  }
}
