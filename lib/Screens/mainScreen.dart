
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'activitiesScreen.dart';
import 'homeScreen.dart';
import 'goalsScreen.dart';
import 'package:calories_tracker/components/commonFunctions.dart' as User;




class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}



class _MainScreenState extends State<MainScreen> {

  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen =  const HomeScreen();



  @override
  Widget build(BuildContext buildContext) {

    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),

      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              minWidth: 40,
              onPressed: () {
                setState(() {
                  currentScreen = const HomeScreen();
                  currentTab = 0;
                });
              },
              child: Icon(Icons.bar_chart,
                  color: currentTab == 0 ? Colors.teal : Colors.grey),
            ),

            MaterialButton(
              minWidth: 40,
              onPressed: () {
                setState(() {
                  currentScreen =  const ActivityScreen();
                  currentTab = 1;
                });
              },
              child: Icon(Icons.local_fire_department,
                  color: currentTab == 1 ? Colors.teal : Colors.grey),
            ),
            MaterialButton(
              minWidth: 40,
              onPressed: () {
                setState(() {
                  currentScreen = const GoalsScreen();
                  currentTab = 2;
                });
              },
              child: Icon(Icons.date_range,
                  color: currentTab == 2 ? Colors.teal : Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}

