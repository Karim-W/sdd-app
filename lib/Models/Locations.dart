import 'dart:ffi';

import 'package:playground/Models/violation.dart';

class Location {
  String id, name, city, area, locImg;
  int activeViolation;
  double long, lat;
  Location(this.id, this.activeViolation, this.area, this.city, this.lat,
      this.long, this.name, this.locImg);
}
