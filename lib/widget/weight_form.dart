
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calories_tracker/components/commonFunctions.dart' as User;
import 'package:shared_preferences/shared_preferences.dart';


class UserWeight extends StatefulWidget {
  const UserWeight({super.key});
  @override
  CreateForm createState() => CreateForm();
}

class CreateForm extends State<UserWeight> {

  double weight=0;
  bool showError=false;
  late SharedPreferences pref;

  @override
  void initState() {
    super.initState();
  }
  saveWeight(){
    SharedPreferences.getInstance().then((prefs) {
      setState(() => pref = prefs);
      pref.setDouble("weight", weight);
      User.myWeight=weight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 235,
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Weight',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
                const SizedBox(height: 10),

                TextFormField(

                  decoration:
                       InputDecoration(labelText: 'Weight In Kg',errorText: showError==true?"invalid weight":null),
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
                        weight = double.parse(value);
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
                        onPressed: () {
                          if(weight<10){
                          setState(() {
                            showError=true;
                          });
                        }else{
                            saveWeight();
                            Navigator.pop(context,weight);}

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
