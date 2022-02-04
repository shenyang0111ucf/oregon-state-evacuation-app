import 'package:evac_app/models/drill_event.dart';

void main() {
  var drillEventJson = DrillEvent.example().toJson();
  var drillEvent = DrillEvent.fromJson(drillEventJson);
  print(drillEvent.toJson().toString());
}
