library my_prj.globals;

import 'package:hive/hive.dart';

double myWeight=70;

final _activityBox=Hive.box('activity_box');


Future<void> createMyActivity(Map<String,dynamic> newItem) async{
  await _activityBox.add(newItem);
}


Future<void> updateActivity(int itemKey,Map<String,dynamic> item)async{
  await _activityBox.put(itemKey, item);
}

Future<void>deleteActivity(int itemKey)async{
  await _activityBox.delete(itemKey);
}
double getIntensity(String activity){
  if(activity=="Running"){
    return 7.0;
  }else if(activity=="Walking"){
    return 3.6;
  }else if(activity=="Swimming"){
    return 3.5;
  }else if(activity=="Cycling"){
    return 4.0;
  }else{
    return 8.0;
  }
}
