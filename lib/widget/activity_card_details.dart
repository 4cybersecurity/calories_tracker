import 'package:calories_tracker/components/commonFunctions.dart';
import 'package:flutter/material.dart';
import 'package:calories_tracker/components/commonFunctions.dart' as User;
import 'package:shared_preferences/shared_preferences.dart';

class ActivityCardDetail extends StatefulWidget {
  const ActivityCardDetail(
      {super.key,
      required this.id,
      required this.date,
      required this.type,
      required this.duration,
      required this.done});

  final int id;
  final DateTime date;
  final String type;
  final double duration;
  final bool done;

  @override
  CardDetail createState() => CardDetail();
}

class CardDetail extends State<ActivityCardDetail> {

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

@override
  void initState() {
    // TODO: implement initState
  getWeight();

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(10),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(widget.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Text(
                    'Date : ${widget.date.toString().split(" ")[0].split("-")[2]} - ${widget.date.toString().split(" ")[0].split("-")[1]} - ${widget.date.toString().split(" ")[0].split("-")[0]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Text('Duration : ${widget.duration} minutes',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    )),
                const SizedBox(
                  height: 30,
                ),

                Text.rich(TextSpan(children: [
                  TextSpan(
                      text:
                          'Burned Calories : ${calculateCalorie(getIntensity(widget.type), widget.duration).toStringAsFixed(2)} ',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)),
                ])),

              ],
            )));
  }

}calculateCalorie(double intensity, double duration,) {

  return (intensity * 3.5 * User.myWeight * duration) / 200;
}
