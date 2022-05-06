import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';

abstract class TaskResult {
  Map<String, dynamic> toJson();

  DrillTaskType taskType();
  String taskID();
}
