import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/drill_task.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/allow_location_permissions_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/perform_drill_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/survey_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/travel_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/wait_for_start_details.dart';

/// Drills are defined by their details. Therefore, this DrillDetails model contains all of the necessary information for the app to
///   (1) administer a drill to a participant,
///   (2) generate the associated datasets, and
///   (3) deliver those datasets back to the researchers in the format they so choose.

class DrillDetails {
  static const DrillType drillType = DrillType.TSUNAMI;
  final String drillID; // fill in when parsing from Firestore
  final String inviteCode;
  final String title;
  final String meetingLocationPlainText;
  final DateTime meetingDateTime;
  final String? blurb;
  final String? description;
  final String publicKey;
  final List<DrillTask> tasks;
  // final String? gcp_endpoint_url;

  DrillDetails({
    required this.drillID,
    required this.inviteCode,
    required this.title,
    required this.meetingLocationPlainText,
    required this.meetingDateTime,
    required this.publicKey,
    required this.tasks,
    this.blurb,
    this.description,
  });

  DrillDetails.example()
      : drillID = '123abc',
        inviteCode = '876543',
        title = 'Example Tsunami Evacuation Drill',
        meetingLocationPlainText = 'Oceanside, OR',
        meetingDateTime =
            DateTime.tryParse('2022-05-2 11:00') ?? DateTime.now(), // bad...
        blurb =
            'Help us evaluate the current evacuation infrastructure of Oceanside!',
        description = null,
        publicKey = 'abc123',
        tasks = [
          DrillTask(
            index: 0,
            taskID: 'abc123-0',
            taskType: DrillTaskType.TRAVEL,
            details: TravelDetails.example("Meet Researchers"),
          ),
          DrillTask(
            index: 1,
            taskID: 'abc123-1',
            taskType: DrillTaskType.ALLOW_LOCATION_PERMISSIONS,
            details: AllowLocationPermissionsDetails.example(),
          ),
          DrillTask(
            index: 2,
            taskID: 'abc123-2',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePre("Pre-Drill"),
          ),
          DrillTask(
            index: 3,
            taskID: 'abc123-3',
            taskType: DrillTaskType.TRAVEL,
            details: TravelDetails.example("Go to Drill-Start Location"),
          ),
          DrillTask(
            index: 4,
            taskID: 'abc123-4',
            taskType: DrillTaskType.WAIT_FOR_START,
            details: WaitForStartDetails.example(),
          ),
          DrillTask(
            index: 5,
            taskID: 'abc123-5',
            taskType: DrillTaskType.PERFORM_DRILL,
            details: PerformDrillDetails.example(),
          ),
          DrillTask(
            index: 6,
            taskID: 'abc123-6',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePost("Post-Drill"),
          ),
          DrillTask(
            index: 7,
            taskID: 'abc123-7',
            taskType: DrillTaskType.TRAVEL,
            details: TravelDetails.example("Regroup with Researchers"),
          ),
        ];

  factory DrillDetails.fromJson(Map<String, dynamic> json, String drillID) {
    // parse the drillTasks
    List<DrillTask> drillTasks = [];
    int taskIndex = 0;
    for (var drillTaskJson in json['tasks']) {
      drillTasks.add(DrillTask.fromJson(drillTaskJson, taskIndex));
      taskIndex++;
    }
    if (drillTasks.isEmpty) {
      throw Exception('DrillDetails: no tasks parsed from DrillDetails json');
    }

    // parse the meeting DateTime
    DateTime? meetingDateTime;
    try {
      meetingDateTime = DateTime.tryParse(json['startTime']);
    } catch (e) {
      throw Exception(
          'DrillDetails: could not parse meetingDatTime from json value:\n$e');
    }
    if (meetingDateTime == null) {
      throw Exception(
          'DrillDetails: could not parse meetingDatTime from json value');
    }

    // return the actual object
    return DrillDetails(
      drillID: drillID, // fill in when parsing from Firestore
      inviteCode: json['inviteCode'],
      title: json['title'],
      meetingLocationPlainText: json['meetingLocationPlainText'],
      meetingDateTime: meetingDateTime,
      blurb: json['blurb'],
      description: json['description'],
      publicKey: json['publicKey'],
      tasks: drillTasks,
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> tasksJsonList = [];
    for (var task in tasks) {
      tasksJsonList.add(task.toJson());
    }
    if (tasksJsonList.isEmpty) {
      throw Exception('DrillDetails: could not parse tasks to jsons');
    }
    return {
      'drillID': drillID, // fill in when parsing from Firestore
      'inviteCode': inviteCode,
      'title': title,
      'meetingLocationPlainText': meetingLocationPlainText,
      'meetingDateTime': meetingDateTime,
      'blurb': blurb,
      'description': description,
      'publicKey': publicKey,
      'tasks': tasksJsonList,
    };
  }
}
