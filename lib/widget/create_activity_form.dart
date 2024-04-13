
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calories_tracker/components/commonFunctions.dart';


class CreateActivity extends StatefulWidget {
  const CreateActivity({super.key,required this.done});
final bool done;
  @override
  CreateForm createState() => CreateForm();
}

class CreateForm extends State<CreateActivity> {
  String type = 'Walking';
  DateTime selectedDate = DateTime.now();
  double duration = 0;
  bool showError=false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 435,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  widget.done==true?'Create Activity':'Create Goal',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Type',
                  ),
                  value: type,
                  items: const [
                    DropdownMenuItem(
                        value: 'Walking', child: Text('Walking')),
                    DropdownMenuItem(
                        value: 'Exercises', child: Text('Exercises')),
                    DropdownMenuItem(
                        value: 'Cycling', child: Text('Cycling')),
                    DropdownMenuItem(
                        value: 'Running', child: Text('Running')),
                    DropdownMenuItem(
                        value: 'Swimming', child: Text('Swimming')),
                  ],

                  onChanged: (String? value) {
                    setState(() {
                      type = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DateTimeFormField(

                  decoration: const InputDecoration(
                    labelText: 'Enter Date',
                  ),
                  firstDate: widget.done==true?DateTime(2020):DateTime.now(),
                  lastDate: widget.done==true?DateTime.now():DateTime(2030),
                  initialPickerDateTime: DateTime.now(),
                  onChanged: (DateTime? value) {
                    selectedDate = value!;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration:
                   InputDecoration(labelText: 'Duration in Minutes',errorText: showError==true?"invalid Duration":null),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],

                  onChanged: (String? value) {
                    setState(() {
                      if(value!.startsWith("0") || value=="" ){
                        showError=true;
                      }else{
                        showError=false;
                        duration = double.parse(value);
                      }
                    });
                  },

                ),


            const SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal),
                        onPressed: () => {
                          if(duration==0){
                        setState(() {showError=true;})
                          }else
    {
                            createMyActivity({
                              'type':type,
                              'date':selectedDate,
                              'duration':duration,
                              'intensity':getIntensity(type),
                              'done':widget.done,
                            }),
                            Navigator.of(context).pop()
                          }

                            },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

}
