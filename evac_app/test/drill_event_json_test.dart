import 'dart:convert';

import 'package:evac_app/models/drill_event.dart';

void main() {
  var drillEventJson = DrillEvent.example().toJson();
  var drillEvent = DrillEvent.fromJson(drillEventJson);
  var encoded = jsonEncode(drillEvent.toJson());
  var newDrillEvent = DrillEvent.fromJson(jsonDecode(encoded));
  print(jsonEncode(newDrillEvent.toJson()));
}
