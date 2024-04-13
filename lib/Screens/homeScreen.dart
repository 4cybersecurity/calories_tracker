import 'package:calories_tracker/Screens/reminderScreen.dart';
import 'package:calories_tracker/components/commonFunctions.dart';
import 'package:calories_tracker/widget/weight_form.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widget/activity_overview_card.dart';
import 'package:calories_tracker/components/commonFunctions.dart' as User;



class GDPData {
  GDPData(this.type, this.calories);
  final String type;
  final double calories;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomePage createState() => _HomePage();
}



class _HomePage extends State<HomeScreen> {
  int selectedControl = 0;
  late List<GDPData> _chartData;
  final _activityBox=Hive.box('activity_box');
  late List<Map<String, dynamic>> data;
  late SharedPreferences pref;

  DateTime weeklyPeriod = DateTime.now().subtract(Duration(days: DateTime.now().weekday));
  DateTime monthlyPeriod = DateTime.now().subtract(Duration(days: DateTime.now().day));
  DateTime yearlyPeriod = DateTime.now().subtract( Duration(days: DateTime.now().difference(DateTime(DateTime.now().year,DateTime.january)).inDays+1));

  Map<dynamic, Widget> children = <dynamic, Widget>{
    0: const Text(
      'Week',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    1: const Text(
      'Month',
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    2: const Text(
      'Year',
      style: TextStyle(fontWeight: FontWeight.bold),
    )
  };
  calculateCalorie(double intensity, double duration,) {

    return (intensity * 3.5 * User.myWeight * duration) / 200;
  }
  @override
  void initState() {
    // TODO: implement initState
    getWeight();
    super.initState();
  }
  getWeight() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getDouble("weight")==null){
      setState(() {
        User.myWeight = prefs.setDouble("weight",70) as double;
      });

    }else {
      double? weight = prefs.getDouble("weight");
      setState(() {
        User.myWeight=weight!;
      });

    }

  }


  List<GDPData> getChartData(List<Map<String, dynamic>> myItems) {

    final List<GDPData> chartData = [];

    Map<T, U> groupByListAndApply<T, U, V, W>(
        List<V> list,
        T Function(V) groupByGetter,
        W Function(V) mapItem,
        U Function(List<W>) applyFunction) {
      Map<T, List<V>> tmpMap = groupBy<V, T>(list, groupByGetter);
      return tmpMap.map((key, value) =>
          MapEntry(key, applyFunction(value.map((e) => mapItem(e)).toList())));
    }

     double sum(List<double> list) =>
         list.fold(0, (previousValue, element) => previousValue + element);
     Map<String, double> map = groupByListAndApply<String,double,Map<String, dynamic>,double>(
         myItems, (e) => (e['type']), (e) => calculateCalorie(getIntensity(e['type']),e['duration']) *1.0, (e) => sum(e));
    for(int i=0;i<map.length;i++){
      chartData.add(GDPData(map.keys.elementAt(i), double.parse(map.values.elementAt(i).toStringAsFixed(2))));
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {

    Map<String, double > activitiesSummary = {};
    if (selectedControl == 0) {
      data = _activityBox.keys.map((key) {
        final item = _activityBox.get(key);
        return {
          "key": key,
          "type": item["type"],
          "date": item['date'],
          "duration": item["duration"],
          "done": item['done']
        };
      }).where((element) =>
      (element['date'] as DateTime).isAfter(weeklyPeriod) &&
          element['done'] == true).toList();
    }else if (selectedControl == 1) {
      data = _activityBox.keys.map((key) {
        final item = _activityBox.get(key);
        return {
          "key": key,
          "type": item["type"],
          "date": item['date'],
          "duration": item["duration"],
          "done": item['done']
        };
      }).where((element) =>
      (element['date'] as DateTime).isAfter(monthlyPeriod) &&
          element['done'] == true).toList();
    }
    else if (selectedControl == 2) {
      data = _activityBox.keys.map((key) {
        final item = _activityBox.get(key);
        return {
          "key": key,
          "type": item["type"],
          "date": item['date'],
          "duration": item["duration"],
          "done": item['done']
        };
      }).where((element) =>
      (element['date'] as DateTime).isAfter(yearlyPeriod) &&
          element['done'] == true).toList();
    }
    setState(() {
      data.reversed.toList();
    });
    for(var a in data){
      activitiesSummary.update(
          a['type'], (value) => a['duration'] + value,
          ifAbsent: () => a['duration']);
    }
_chartData = getChartData(data);

    data=_activityBox.keys.map((key) {
      final item=_activityBox.get(key);
      return {"key":key,"type":item["type"],"date":item['date'],"duration":item["duration"],"intensity":item['intensity'],"done":item['done']};
    }).where((element) => element['done']==false && (element['date'] as DateTime).day==DateTime.now().day).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () async {
          showDialog(context: context, builder: (context)=> const UserWeight()).then((value) => setState(() {
            
          }));
        }, icon: Icon(Icons.person,size: 32,color: Colors.white,),),
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReminderScreen()
              ),
            ).then((value) => setState(() {}));
          }, icon: Icon(Icons.notifications,size: 32,color: data.isEmpty?Colors.white:Colors.red,),),
        ],
        backgroundColor: Colors.teal,

      ),
      body:Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Center(
            child: CupertinoSlidingSegmentedControl(
              groupValue: selectedControl,
              children: children,

              onValueChanged: (value) {
                setState(() {
                  selectedControl = value;
                });
              },
            ),
          ),
          SizedBox(height: 20,),

          SfCircularChart(
            margin: const EdgeInsets.only(top: 10),
            legend: const Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap,position: LegendPosition.top),
            series: <CircularSeries>[
              DoughnutSeries<GDPData, String>(
                dataSource: _chartData,
                xValueMapper: (GDPData data, _) => data.type,
                yValueMapper: (GDPData data, _) => data.calories,
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              )
            ],
          ),
          SizedBox(
            height: 260,
            child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder:
                    (BuildContext context, int index) =>
                const SizedBox(
                  height: 5,
                ),
                padding: const EdgeInsets.all(8.0),
                itemCount: activitiesSummary.length,
                itemBuilder: (BuildContext context, int index) {
                  String key = activitiesSummary.keys.elementAt(index);
                  return ActivityOverviewCard(type: key, duration: activitiesSummary[key]!);
                }),
          ),

        ],
      )

    );
  }
}
