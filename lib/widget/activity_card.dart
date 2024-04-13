import 'package:flutter/material.dart';

import '../components/commonFunctions.dart';
import 'activity_card_details.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard(
      {super.key,
      required this.id,
      required this.date,
      required this.type,
      required this.duration,
      required this.index,
      required this.done,
      required this.callBack});

  final int id;
  final DateTime date;
  final String type;
  final double duration;
  final int index;
  final bool done;
  final Function callBack;

  @override
  Card createState() => Card();
}

class Card extends State<ActivityCard> {
  @override
  Widget build(BuildContext context) {

    return ListTile(
      trailing: _buildConditionalTrailing(widget.done,widget.callBack),

      onTap: () {
        showDialog(
            context: context,
            builder: (context) => ActivityCardDetail(
                  id: widget.id,
                  date: widget.date,
                  type: widget.type,
                  duration: widget.duration,
                  done: widget.done,
                ));
      },
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
        widget.type,
        //dayToString(widget.date.weekday),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${widget.date.toString().split(" ")[0].split("-")[2]} - ${ widget.date.toString().split(" ")[0].split("-")[1]} - ${widget.date.toString().split(" ")[0].split("-")[0]} ~ ${widget.duration.toStringAsFixed(0)} min',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }




  Widget _buildConditionalTrailing(bool condition,Function call) {
    return condition
        ? const Icon(Icons.check_box, color: Colors.green)
        : IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No')),
                    TextButton(
                        onPressed: () {
                          updateActivity(widget.id,{
                            'type':widget.type,
                            'date':DateTime.now(),
                            'duration':widget.duration,
                            'done':true,
                          });
                          call();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                  ],
                  title: const Text('Change Status'),
                  content: const Text('Do you want to change status?'),
                  contentPadding: const EdgeInsets.all(20.0),
                ),
              );
            },
            icon: const Icon(
              Icons.check_box_outlined,
              color: Colors.green,
            ));
  }
}
