import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';

class WaitForStartDetails extends TaskDetails {
  /// if(PerformDrillDetails.trackingLocation)
  ///     `WaitForStart` task should also `AcquireGPS`
  final String taskID;
  final String performDrillTaskID;
  final TypeOfWait typeOfWait;
  final Map<String, dynamic>? content;
  // that's right, there's potentially one more level required to do some tasks right. We could instead define three different `DrillTaskType`s for three current types of WaitForStart, but that complicates things too much on the backend (drill creation and whatnot).
  // for now, let's only implement `SELF` and make the other two throw `UnimplementedError`

  WaitForStartDetails({
    required this.taskID,
    required this.performDrillTaskID,
    required this.typeOfWait,
    this.content = null,
  });

  WaitForStartDetails.self({
    required this.taskID,
    required this.performDrillTaskID,
  })  : content = null,
        typeOfWait = TypeOfWait.SELF;

  WaitForStartDetails.example(this.taskID)
      : performDrillTaskID = 'abc123',
        content = null,
        typeOfWait = TypeOfWait.SELF;

  factory WaitForStartDetails.fromJson(Map<String, dynamic> json) {
    TypeOfWait thisType = TypeOfWait.values
        .firstWhere((e) => e.toString() == 'TypeOfWait.' + json['typeOfWait']);
    return WaitForStartDetails(
      taskID: json['taskID'],
      performDrillTaskID: json['performDrillTaskID'],
      typeOfWait: thisType,
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'taskID': taskID,
        'performDrillTaskID': performDrillTaskID,
        'typeOfWait': typeOfWait.name,
        'content': content,
      };
}
