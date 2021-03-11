// TODO Implement this library.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:playground/Models/manager.dart';
import 'package:playground/Models/violation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'violationView.dart';

class storeHistoryView extends StatefulWidget {
  storeHistoryView({this.storeID, this.longCord, this.latCord});
  //final FirebaseApp app;
  final storeID;
  final longCord;
  final latCord;
  @override
  State<StatefulWidget> createState() {
    return _storeHistoryView(
        sID: storeID, LongCord: longCord, LatCord: latCord);
  }
}

class _storeHistoryView extends State<storeHistoryView> {
  _storeHistoryView({this.sID, this.LongCord, this.LatCord});
  final sID;
  final LongCord;
  final LatCord;
  List<Violation> violations = [];
  @override
  void initState() {
    super.initState();
    DatabaseReference Dbref = FirebaseDatabase.instance
        .reference()
        .child("Locations")
        .child(sID)
        .child("violations");
    Dbref.once().then((DataSnapshot dataSnapShot) {
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      for (var k in keys) {
        Violation v = new Violation(
            values[k]['time'], values[k]['photo'], values[k]['date']);
        if (v.photo == 'n/a') {
          v.photo =
              'https://neurohive.io/wp-content/uploads/2020/04/rsz_ki_social_distancing_detektor-scaled.jpg';
        }
        violations.add(v);
      }

      setState(() {});
      print(violations);
    });
  }

  String _storeID;
  final databaseReference = FirebaseDatabase.instance;
  @override
  Widget build(BuildContextcontext) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Violations History",
            style: TextStyle(color: Colors.black),
          ),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )),
      body: ListView.builder(
          itemCount: violations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  print(violations.elementAt(index).time);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => violationView(
                              violationInst: violations.elementAt(index),
                              longCord: LongCord,
                              latCord: LatCord)));
                },
                title: Text(violations.elementAt(index).date +
                    " " +
                    violations.elementAt(index).time));
          }),
    );
  }
}
