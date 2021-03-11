import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/rendering.dart';
import 'package:playground/Models/manager.dart';
import 'package:playground/Models/violation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class violationView extends StatefulWidget {
  violationView({this.violationInst, this.longCord, this.latCord});
  //final FirebaseApp app;
  final violationInst;
  final longCord;
  final latCord;
  @override
  State<StatefulWidget> createState() {
    return _violationView(
        ViolationInst: violationInst, LongCord: longCord, LatCord: latCord);
  }
}

class _violationView extends State<violationView> {
  _violationView({this.ViolationInst, this.LongCord, this.LatCord});
  final ViolationInst;
  final LongCord;
  final LatCord;
  List<Violation> violations = [];
  List<Marker> _markers = <Marker>[];

  @override
  String _storeID;
  final databaseReference = FirebaseDatabase.instance;
  @override
  Widget build(BuildContextcontext) {
    return new Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Violation Information",
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
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return DetailScreen(ViolationInst.photo);
                  }));
                },
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(ViolationInst.photo,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.height * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3),
                  ),
                )),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                "Date: " + ViolationInst.date,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0),
              child: Text(
                "Time: " + ViolationInst.time,
                style: TextStyle(fontSize: 24),
              ),
            ),
            Spacer(),
            Padding(
                padding: EdgeInsets.all(1),
                child: SizedBox(
                  width: (MediaQuery.of(context).size.width - 8),
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(LatCord, LongCord),
                      zoom: 18,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _markers.add(Marker(
                          markerId: MarkerId('SomeId'),
                          position: LatLng(LatCord, LongCord),
                          infoWindow: InfoWindow(title: 'Store Location')));
                      setState(() {});
                      //controller.complete(controller);
                    },
                    markers: Set<Marker>.of(_markers),
                  ),
                )),
            Spacer()
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen(this.yorl);

  final String yorl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              "Violation Image",
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
        body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            // child: PinchZoomImage(
            //   image: ClipRRect(
            //     child: Image.network(
            //       yorl,
            //     ),
            //   ),
            //   zoomedBackgroundColor: Color.fromRGBO(240, 240, 240, 1.0),
            //   hideStatusBarWhileZooming: true,
            //   onZoomStart: () {
            //     print('Zoom started');
            //   },
            //   onZoomEnd: () {
            //     print('Zoom finished');
            //   },
            // ),
          ),
          // decoration: BoxDecoration(
          //   color: Colors.black,
          //   image: DecorationImage(
          //     fit: BoxFit.fitWidth,
          //     image: NetworkImage(yorl),
          //     alignment: Alignment.center,
          //   ),
          // ),
        ));
  }
}
