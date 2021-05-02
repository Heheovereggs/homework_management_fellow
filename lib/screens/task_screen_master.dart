import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homework_management_fellow/model/homework.dart';
import 'package:homework_management_fellow/screens/private_task_screen.dart';
import 'package:homework_management_fellow/services/dataService.dart';
import 'package:homework_management_fellow/services/firebaseService.dart';
import 'package:homework_management_fellow/widgets/homework_card.dart';
import 'package:homework_management_fellow/screens/task_create_screen.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:homework_management_fellow/widgets/boxed_text_note.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  void initState() {
    super.initState();
    loadPublicHomeworkList();
  }

  void loadPublicHomeworkList() async {
    List studentSectionIds = Provider.of<DataService>(context, listen: false).student.sectionIds;
    List<Homework> _homeworkList =
        await Provider.of<FirebaseService>(context, listen: false).getPublicHomeWorkList(studentSectionIds);
    Provider.of<DataService>(context, listen: false).initializePublicHomeworkList(_homeworkList);
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async {
    loadPublicHomeworkList();
    _refreshController.refreshCompleted();
  }

  void filterIconOnTap() {
    //TODO: pop up page
  }

  void helpIconOnTap() {
    NoticeDialog(context).showNoticeDialog(
        title: "Homework type",
        bodyText:
            "🟢 Private => only YOURSELF can see this homework\n\n🟢 Public => only student in same SECTION of one specific course can see this homework\n\n🟢 All (a.k.a. announcement) => ALL student in CET is able to see this homework/announcement");
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
                  index == 1 ? Icons.help : Icons.filter_alt,
                  color: Colors.white,
                ),
                onTap: index == 1 ? helpIconOnTap : filterIconOnTap,
              ),
              middle: Text(
                "Search bar will be here",
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
                onForcePressPeak: (ForcePressDetails forcePressDetails) {
                  print("3D Touch activated");
                  if (Provider.of<DataService>(context, listen: false).student.admin) {
                    Navigator.pushNamed(context, '/SudoScreen');
                  } else {
                    NoticeDialog(context).showNoticeDialog(
                        title: "Congratulations",
                        bodyText: "WoW\nYou find this hidden portal!\nBut access denied");
                  }
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
      child: Consumer<DataService>(
        builder: (_, stateService, child) {
          if (stateService.isPublicHomeworkLoaded) {
            return Stack(
              children: [
                SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  enablePullUp: false,
                  enablePullDown: true,
                  header: ClassicHeader(
                    textStyle: Theme.of(context).textTheme.bodyText1,
                  ),
                  enableTwoLevel: false,
                  child: stateService.publicHomeworkList.isNotEmpty
                      ? ListView.builder(
                          itemCount: stateService.publicHomeworkList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return HomeworkCard(stateService.publicHomeworkList[index]);
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
                UserSeeOnlyNotification(
                    visible: stateService.isShowAccessDenyDialogue, text: "Access Denied: you are no admin"),
              ],
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
