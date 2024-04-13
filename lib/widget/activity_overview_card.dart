import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActivityOverviewCard extends StatefulWidget{
  const ActivityOverviewCard({super.key,required this.type,required this.duration});

  final String type;
  final double duration;
  @override
  OverviewCard createState() => OverviewCard();
}

class OverviewCard extends State<ActivityOverviewCard>{
  @override
  Widget build(BuildContext context){
    return ListTile(

      leading: Builder(
        builder: (context) {
          if (widget.type == 'Swimming') {
            return const Icon(
              Icons.pool_outlined,
              color: Colors.black,
            );
          }else if (widget.type == 'Running') {
            return const Icon(
              Icons.directions_run_outlined,
              color: Colors.black,
            );
          } else if(widget.type == 'Cycling'){
            return const Icon(
              Icons.directions_bike_outlined,
              color: Colors.black,
            );
          }else if(widget.type == 'Walking'){
            return const Icon(
              Icons.directions_walk,
              color: Colors.black,
            );
          }
          else {
            return const Icon(
              Icons.fitness_center,
              color: Colors.black,
            );
          }
        },
      ),
      title: Text(
        '${widget.type} ~ ${widget.duration~/60} hour ${(widget.duration%60).toStringAsFixed(0)} min',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}