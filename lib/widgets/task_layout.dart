import 'package:flutter/material.dart';
import 'homework_card.dart';

class TaskScreenLayout {
  final String email;
  final context;

  TaskScreenLayout({this.email, this.context});

  Scaffold taskLayoutGenerator() {
    print("tasktask" + email);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            // TODO: pop up card
          },
          child: Icon(Icons.settings),
        ),
        title: Text("HMF"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list), //filter_alt
            onPressed: () {
              // TODO: pop up card
            },
          ),
          SizedBox(width: 8)
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          // TODO: make ListView builder
          children: _stackGenerator(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          size: 40,
        ),
        onPressed: () {
          // TODO: add pop up panel
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 75,
          child: Row(
            children: [
              IconButton(
                iconSize: 30.0,
                padding: EdgeInsets.only(right: 28.0),
                icon: Icon(Icons.list),
                onPressed: () {
                  // switch to next screen
                },
              ),
              Text(email),
            ],
          ),
        ),
      ),
    );
  }

  List<HomeworkCard> _stackGenerator() {
    return [
      HomeworkCard(name: "101", dueDate: "1212", subject: "123"),
      HomeworkCard(name: "102", dueDate: "1212", subject: "123"),
      HomeworkCard(name: "247", dueDate: "1212", subject: "123"),
      HomeworkCard(name: "206", dueDate: "1212", subject: "123"),
      HomeworkCard(name: "207", dueDate: "1212", subject: "123"),
    ];
  }
}
