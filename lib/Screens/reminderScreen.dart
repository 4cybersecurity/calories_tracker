import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/commonFunctions.dart';
import '../widget/activity_card.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreen createState() => _ReminderScreen();
}

class _ReminderScreen extends State<ReminderScreen> {
  List<Map<String,dynamic>> _items=[];
  final _activityBox=Hive.box('activity_box');


  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data=_activityBox.keys.map((key) {
      final item=_activityBox.get(key);
      return {"key":key,"type":item["type"],"date":item['date'],"duration":item["duration"],"intensity":item['intensity'],"done":item['done']};
    }).where((element) => element['done']==false && (element['date'] as DateTime).day==DateTime.now().day).toList();

    setState(() {
      _items=data.reversed.toList();
    });

    refresh(){
      setState(() {

      });
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon:const Icon(Icons.arrow_back_ios),color: Colors.white, onPressed: () { Navigator.pop(context); },),
          title: const Text(
            'Reminders',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                SizedBox(height: 10.0),
            padding: EdgeInsets.all(8.0),
            itemCount: _items.length,
            itemBuilder: (BuildContext context, int index) {
              var doc = _items[index];
              return Dismissible(
                confirmDismiss: (DismissDirection direction) async {
                  return showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.white,
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel',style: TextStyle(color: Colors.grey))),
                        TextButton(
                            onPressed: () {
                              deleteActivity(doc['key']);
                              Navigator.of(context).pop();
                              setState(() {});

                            },
                            child: const Text('Delete',style: TextStyle(color: Colors.red),)),
                      ],
                      title: const Text('Delete Confirmation'),
                      contentPadding: const EdgeInsets.all(20.0),
                    ),
                  );
                },
                key: UniqueKey(),
                child: ActivityCard(
                  id: doc['key'],
                  date: doc['date'],
                  type: doc['type'],
                  duration: doc['duration'],
                  index: index,
                  done: doc['done'],
                  callBack: refresh,
                ),
              );
            })
    );
    //);
  }
}
