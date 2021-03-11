import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:playground/Models/manager.dart';
import 'package:playground/Models/violation.dart';
import 'package:playground/Views/Analytics.dart';
import 'storeHistoryView.dart';
import 'package:playground/Views/usersetting.dart';
import 'package:playground/Models/CustomShowDialog.dart';

import 'authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Location {
  String id, name, city, area, locImg, lastUpdated;
  int activeViolation;
  double long, lat;
  Location(this.id, this.activeViolation, this.area, this.city, this.lat,
      this.long, this.name, this.locImg, this.lastUpdated);
}

class HomePage extends StatefulWidget {
  HomePage({this.app});
  final FirebaseApp app;
  @override
  State<StatefulWidget> createState() {
    return _myHomePageState();
  }
}

class _myHomePageState extends State<HomePage> {
  List<String> LocationIds = [];
  List<Location> userLocations = [];
  List<int> vioArr = [3, 5, 2, 1, 0];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference Dbref = FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser.uid)
        .child("pairedLocations");
    Dbref.onValue.listen((event) {
      LocationIds.clear();
      userLocations.clear();
      var dataSnapShot = event.snapshot;
      var keys = dataSnapShot.value.keys;
      var values = dataSnapShot.value;
      for (var key in keys) {
        LocationIds.add(key);
        DatabaseReference ref =
            FirebaseDatabase.instance.reference().child("Locations").child(key);
        ref.onValue.listen((event) {
          var dataSnapShots = event.snapshot;
          var keyse = dataSnapShots.value.keys;
          var valuese = dataSnapShots.value;
          print(valuese);
          Location bigL = new Location(
              valuese['id'],
              valuese['activeViolations'],
              valuese['area'],
              valuese['city'],
              valuese['lat'],
              valuese['long'],
              valuese['name'],
              valuese['locImg'],
              valuese['LastUpdated']);
          print(bigL.area);
          bool found = false;
          if (userLocations.isNotEmpty) {
            for (var k in userLocations) {
              if (k.id == bigL.id) {
                found = true;
              }
            }
          }
          if (!found) {
            userLocations.add(bigL);
          }
          setState(() {});
        });
      }
    });
  }

  final databaseReference = FirebaseDatabase.instance;
  @override
  Widget build(BuildContextcontext) {
    final DBref = databaseReference.reference();
    return new Scaffold(
        //backgroundColor: Color(0xff0B0500),
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              Navigator.push(context, SlideRightRoute(page: userSetting()));
            },
          ),
          title: Text(
            "Home",
            style: TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            FlatButton(
              //textColor: Colors.white,
              textColor: Colors.black,
              onPressed: () {
                //context.read<AuthenticationService>().signOut();
                var a = userLocations
                    .sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated));
                print(userLocations);
                setState(() => this
                    .userLocations
                    .sort((a, b) => a.lastUpdated.compareTo(b.lastUpdated)));
              },
              child: Text("Logout"),
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              Container(
                child: _buildHorizontalList(
                    w_idth: MediaQuery.of(context).size.width,
                    heigh: MediaQuery.of(context).size.height,
                    parentIndex: 1,
                    locs: userLocations,
                    contex: context),
              ),
            ],
          ),
        ));
  }
}

Widget _buildHorizontalList(
    {double w_idth,
    double heigh,
    int parentIndex,
    List<Location> locs,
    BuildContext contex}) {
  double height = w_idth - 2;
  return SizedBox(
    height: heigh * 0.80,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: locs.length,
        itemBuilder: (BuildContext content, int index) {
          return _buildItem(
              index: index + 1,
              color: Colors.deepPurpleAccent,
              parentSize: height,
              name: locs.elementAt(index).name,
              area: locs.elementAt(index).area,
              city: locs.elementAt(index).city,
              violations: locs.elementAt(index).activeViolation,
              img: locs.elementAt(index).locImg,
              heig: heigh * 0.78, //heigh - 180,
              storeID: locs.elementAt(index).id,
              llong: locs.elementAt(index).long,
              llat: locs.elementAt(index).lat,
              context: contex);
        }),
  );
}

Widget _buildItem(
    {int index,
    Color color,
    double parentSize,
    String name,
    String area,
    String city,
    int violations,
    String img,
    double heig,
    String storeID,
    double llong,
    double llat,
    BuildContext context}) {
  double edgeSize = 8.0;
  double itemSize = parentSize - edgeSize * 2.0;
  if (img == 'n/a') {
    img =
        'https://coolbackgrounds.io/images/backgrounds/black/pure-black-background-f82588d3.jpg';
  }
  return Container(
    padding: EdgeInsets.all(edgeSize),
    child: InkWell(
      onTap: () {
        print("hi");
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => storeHistoryView(
                  storeID: storeID, longCord: llong, latCord: llat),
            ));
      }, // Handle your callback
      child: SizedBox(
        width: itemSize,
        height: itemSize,
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: color,
                gradient: new LinearGradient(
                    colors: [Colors.grey, color.withOpacity(0.75)],
                    begin: Alignment.centerRight,
                    end: new Alignment(-1.0, -1.0)),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitHeight, image: NetworkImage(img)),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                alignment: Alignment.bottomCenter, //.bottomCenter,
                child: Padding(
                    padding: EdgeInsets.only(top: (heig - 190)),
                    child: SizedBox(
                      width: itemSize,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              color: color,
                              gradient: new LinearGradient(
                                  colors: [
                                    Colors.grey.withOpacity(0.0),
                                    Colors.white.withOpacity(0.0)
                                  ],
                                  begin: Alignment.topLeft,
                                  end: new Alignment(-1.0, -1.0)),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(children: [
                            Text(
                              name,
                              style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(1.5, 1.5),
                                        blurRadius: 3.0,
                                        color: Colors.black),
                                    Shadow(
                                      offset: Offset(1.5, 1.5),
                                      blurRadius: 8.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(area + "," + city,
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black),
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 8.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                            Text(
                                "Number of Violations: " +
                                    violations.toString(),
                                style: TextStyle(
                                  shadows: <Shadow>[
                                    Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 3.0,
                                        color: Colors.black),
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 8.0,
                                      color: Colors.black,
                                    ),
                                  ],
                                  color: Colors.white,
                                  fontSize: 20,
                                )),
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RawMaterialButton(
                                    onPressed: () {
                                      print("Show graph");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Analytics(storeID),
                                          ));
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(
                                      Icons.insert_chart,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () {
                                      _confirmDelet(context, storeID);
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    child: Icon(
                                      Icons.delete,
                                      size: 35.0,
                                    ),
                                    padding: EdgeInsets.all(15.0),
                                    shape: CircleBorder(),
                                  ),
                                ],
                              ),
                            ),
                          ])),
                    ))),
          ),
        ),
      ),
    ),
  );
}

void _confirmDelet(context, loc_ID) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return new CustomAlertDialog(
          content: new Container(
              width: 300,
              height: 200,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: const Color(0xFFFFFF),
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
              ),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "Are You Sure?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    Spacer(),
                    Text(
                      "Please click confirm if you would like to remove this location from your list, if you would like to dismiss please click cancel.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Text("Confirm"),
                              color: Colors.black,
                              textColor: Colors.white,
                              onPressed: () {
                                DatabaseReference Dbref = FirebaseDatabase
                                    .instance
                                    .reference()
                                    .child("users")
                                    .child(
                                        FirebaseAuth.instance.currentUser.uid)
                                    .child("pairedLocations");
                                Dbref.child(loc_ID).remove();
                                print("Confirm delete of " + loc_ID);
                                Navigator.of(context).pop();
                              },
                            )),
                        Spacer(),
                        Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: Text("Cancel"),
                              color: Colors.black,
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )),
                        Spacer(),
                      ],
                    )
                  ],
                ),
              )),
        );
      });
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

// class HomePage extends StatelessWidget {
//   manager user;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text("HOME"),
//             RaisedButton(
//               onPressed: () {
//                 context.read<AuthenticationService>().signOut();
//               },
//               child: Text("Sign out"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
