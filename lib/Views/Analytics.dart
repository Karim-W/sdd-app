import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

import 'indicator.dart';

class Analytics extends StatefulWidget {
  Analytics(this.loc);
  final loc;
  final List<Color> availableColors = [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];
  @override
  State<StatefulWidget> createState() {
    return _Analytics(loc);
  }
}

final Color barBackgroundColor = Colors.black;
final Duration animDuration = const Duration(milliseconds: 250);

int touchedIndex;

bool isPlaying = false;

class _Analytics extends State<Analytics> {
  _Analytics(this.loc);
  final loc;
  List<double> count = [];
  List<String> days = [];
  List<double> dailyViolations = [];
  var totalCases = 0.0;
  var data = [3.0, 1.0, 2.0, 3.0, 0.0, 1.0, 0.0, 4.0, 2.0, 5.0, 3.0];
  var lastE = 0;
  var today = 0.0;
  List<String> name = [
    "01-03-2021",
    "02-03-2021",
    "03-03-2021",
    "04-03-2021",
    "05-03-2021",
    "06-03-2021",
    "07-03-2021",
    "08-03-2021",
    "09-03-2021",
    "10-03-2021",
    "11-03-2021",
  ];
  String input;
  double todayPortion = 1;
  double totalV = 1;

  @override
  void initState() {
    DatabaseReference Dbref = FirebaseDatabase.instance
        .reference()
        .child("Locations")
        .child(loc)
        .child("Analytics");
    var i = 0;
    Dbref.onValue.listen((event) {
      var dataSnapShot = event.snapshot;
      var keys = dataSnapShot.value.keys;
      for (var K in keys) {
        print(K);
        Dbref.child(K.toString()).onValue.listen((eve) {
          var dSS = eve.snapshot;
          var val = dSS.value;
          var cC = val['Count'];
          double cf = double.parse(cC.toString());
          totalCases += cf;
          count.add(cf);
          days.add(K);
          if (i < 7) {
            dailyViolations.add(cf);
            i++;
          }
        });
      }
      // for (var i = 0; i < 7; i++) {
      //   dailyViolations.add(count.elementAt(count.length - i));
      // }
      setState(() {});
      // var values = dataSnapShot.value;
    });
  }

  @override
  Widget build(BuildContextcontext) {
    var listV = "Violations in the Last 7 Days";

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "Store Analytics",
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
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: ListView.builder(
                  itemExtent: MediaQuery.of(context).size.width,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18)),
                          color: const Color(0xff81e5cd),
                          child: Stack(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      "Violations",
                                      style: TextStyle(
                                          color: const Color(0xff0f4a3c),
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      listV,
                                      style: TextStyle(
                                          color: const Color(0xff379982),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 38,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: BarChart(
                                          isPlaying
                                              ? randomData()
                                              : mainBarData(),
                                          swapAnimationDuration: animDuration,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: const Color(0xff0f4a3c),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPlaying = !isPlaying;
                                        if (isPlaying) {
                                          refreshState();
                                        }
                                      });
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )),
                  itemCount: 1),
            ),
          ),
          // SliverGrid.count(
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Container(
          //         height: 900,
          //         child: Material(
          //           color: Colors.black,
          //           elevation: 22.0,
          //           borderRadius: BorderRadius.circular(24.0),
          //           child:
          //         ),
          //       ),
          //     ),
          //     // Padding(
          //     //   padding: const EdgeInsets.all(8.0),
          //     //   child: Material(
          //     //     color: Colors.black,
          //     //     elevation: 22.0,
          //     //     borderRadius: BorderRadius.circular(24.0),
          //     //   ),
          //     // ),
          //   ],
          //   crossAxisCount: 1,
          //   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //   //   crossAxisCount: 2,
          //   //   childAspectRatio: 1.5,
          //   // ),
          //   // delegate: SliverChildBuilderDelegate(
          //   //   (context, index) => Container(
          //   //     margin: EdgeInsets.all(5.0),
          //   //     color: Colors.yellow,
          //   //   ),
          //   // ),
          // ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 22.0,
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(24.0),
                  child: Row(
                    children: [
                      Spacer(),
                      Expanded(
                        child: AspectRatio(
                          aspectRatio: 2,
                          child: PieChart(
                            PieChartData(
                                pieTouchData: PieTouchData(
                                    touchCallback: (pieTouchResponse) {
                                  setState(() {});
                                }),
                                startDegreeOffset: 270,
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 0,
                                sections: showingSections()),
                          ),
                        ),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Spacer(
                            flex: 6,
                          ),
                          Indicator(
                            color: Colors.white,
                            text: "Today's Cases",
                            isSquare: false,
                            size: touchedIndex == 0 ? 18 : 16,
                            textColor: Colors.white,
                          ),
                          Text(
                            "5",
                            style: TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Indicator(
                            color: Colors.orange[500],
                            text: "Rest of cases",
                            isSquare: false,
                            size: touchedIndex == 0 ? 18 : 16,
                            textColor: Colors.orange[500],
                          ),
                          Text(
                            "6",
                            style: TextStyle(color: Colors.white),
                          ),
                          Spacer(),
                          Text(
                            "Total Cases: 11",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(
                            flex: 20,
                          )
                        ],
                      ),
                      Spacer()
                    ],
                  ),
                ),
              ),
            ),
          ),
          // SliverToBoxAdapter(
          //   child: SizedBox(
          //     height: MediaQuery.of(context).size.height * 0.35,
          //     child: ListView.builder(
          //         itemExtent: MediaQuery.of(context).size.width,
          //         scrollDirection: Axis.horizontal,
          //         itemBuilder: (context, index) => Container(
          //               margin: EdgeInsets.all(8.0),
          //               child: Material(
          //                   color: Colors.black,
          //                   elevation: 22.0,
          //                   borderRadius: BorderRadius.circular(24.0),
          //                   child: Column(
          //                     children: <Widget>[
          //                       const SizedBox(
          //                         height: 28,
          //                       ),
          //                       const SizedBox(
          //                         height: 18,
          //                       ),
          //                     ],
          //                   )),
          //             ),
          //         itemCount: 1),
          //   ),
          // ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? [Colors.yellow] : [barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        while (dailyViolations.length < 7) {
          dailyViolations.add(0);
        }
        print(dailyViolations);
        print(dailyViolations.length);
        var len = dailyViolations.length - 1;
        switch (i) {
          case 0:
            return makeGroupData(0, dailyViolations.elementAt(len - 6),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, dailyViolations.elementAt(len - 5),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, dailyViolations.elementAt(len - 4),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, dailyViolations.elementAt(len - 3),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, dailyViolations.elementAt(len - 2),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, dailyViolations.elementAt(len - 1),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, dailyViolations.elementAt(len),
                isTouched: i == touchedIndex);
          default:
            return null;
        }
      });

  List<PieChartSectionData> showingSections() {
    lastE = count.length - 1;
    today = count.elementAt(lastE);
    return List.generate(
      2,
      (i) {
        final isTouched = i == touchedIndex;
        final double opacity = isTouched ? 1 : 0.6;
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: Colors.white,
              value: 5,
              title: today.toString(),
              radius: 80,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: Colors.orange[500],
              value: totalCases - today,
              title: (totalCases - today).toString(),
              radius: 65,
              titleStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              titlePositionPercentageOffset: 0.55,
            );

          default:
            return null;
        }
      },
    );
  }

  BarChartData mainBarData() {
    int days = dailyViolations.length;
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Monday';
                  break;
                case 1:
                  weekDay = 'Tuesday';
                  break;
                case 2:
                  weekDay = 'Wednesday';
                  break;
                case 3:
                  weekDay = 'Thursday';
                  break;
                case 4:
                  weekDay = 'Friday';
                  break;
                case 5:
                  weekDay = 'Saturday';
                  break;
                case 6:
                  weekDay = 'Sunday';
                  break;
              }
              return BarTooltipItem(weekDay + '\n' + (rod.y - 1).toString(),
                  TextStyle(color: Colors.yellow));
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'M';
              case 1:
                return 'T';
              case 2:
                return 'W';
              case 3:
                return 'T';
              case 4:
                return 'F';
              case 5:
                return 'S';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 1:
            return makeGroupData(1, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 2:
            return makeGroupData(2, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 3:
            return makeGroupData(3, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 4:
            return makeGroupData(4, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 5:
            return makeGroupData(5, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          case 6:
            return makeGroupData(6, Random().nextInt(15).toDouble() + 6,
                barColor: widget.availableColors[
                    Random().nextInt(widget.availableColors.length)]);
          default:
            return null;
        }
      }),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
        animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }

  // print(count);
  // print(days);
  // totalV = data.fold(0, (previous, current) => previous + current);
  // todayPortion = (data.last / totalV) * 100;
  // Map<String, double> dataMap = {
  //   "Today's Percentage": todayPortion,
  //   "Total Violations": 100 - todayPortion
  // };
  // var padd = (MediaQuery.of(context).size.width - 40) / (2 * days.length);
  // var floorToDouble = padd.floorToDouble();
  // return new Scaffold(
  //     appBar: AppBar(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         title: Text(
  //           "Store Analytics",
  //           style: TextStyle(color: Colors.black),
  //         ),
  //         automaticallyImplyLeading: true,
  //         leading: IconButton(
  //           icon: Icon(
  //             Icons.arrow_back,
  //             color: Colors.black,
  //           ),
  //           onPressed: () {
  //             Navigator.pop(context, true);
  //           },
  //         )),
  //     body: Container(
  //         child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Container(
  //                 child: Column(children: [
  //               SizedBox(
  //                 width: MediaQuery.of(context).size.width,
  //                 height: MediaQuery.of(context).size.height * 0.4,
  //                 child: Container(
  //                   child: Material(
  //                     color: Colors.black,
  //                     elevation: 22.0,
  //                     borderRadius: BorderRadius.circular(24.0),
  //                     child: Padding(
  //                       padding: EdgeInsets.only(
  //                           top: 8.0, bottom: 8.0, left: 20, right: 20),
  //                       child: Column(
  //                         children: [
  //                           Spacer(),
  //                           Text(
  //                             "Total Number of Violations",
  //                             style: TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 24,
  //                             ),
  //                           ),
  //                           Spacer(),
  //                           Padding(
  //                             padding: EdgeInsets.all(8),
  //                             child: Sparkline(
  //                               data: count,
  //                               lineColor: Colors.orange,
  //                               fillMode: FillMode.below,
  //                               fillGradient: new LinearGradient(
  //                                 begin: Alignment.topCenter,
  //                                 end: Alignment.bottomCenter,
  //                                 colors: [
  //                                   Colors.orange[800],
  //                                   Colors.orange[400]
  //                                 ],
  //                               ),
  //                               pointsMode: PointsMode.all,
  //                               pointSize: 8.0,
  //                               pointColor: Colors.white,
  //                             ),
  //                           ),
  //                           Spacer(),
  //                           Row(
  //                             children: [
  //                               for (var i in days)
  //                                 Padding(
  //                                   padding: EdgeInsets.only(
  //                                       left: 0, right: padd * 2),
  //                                   child: RotatedBox(
  //                                     quarterTurns: 1,
  //                                     child: Text(
  //                                       i,
  //                                       style: TextStyle(color: Colors.white),
  //                                     ),
  //                                   ),
  //                                 ),
  //                             ],
  //                           ),
  //                           Spacer()
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             ])))));
  // }
}
