import 'dart:convert';

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
  final DateTime? meetingDateTime;
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
        meetingDateTime = DateTime.tryParse('2022-05-02T13:00:00.000001') ??
            null, // forced nullable on .tryParse(), need to handle...
        blurb =
            'Help us evaluate the current evacuation infrastructure of Oceanside!',
        description = null,
        publicKey = 'abc123',
        tasks = [
          DrillTask(
            index: 0,
            taskID: 'abc123-0',
            taskType: DrillTaskType.TRAVEL,
            title: 'Meet Researchers at Post Office',
            details: TravelDetails.example(
                'Oceanside Post Office', 'Meet Researchers', 'abc123-0'),
          ),
          DrillTask(
            index: 1,
            taskID: 'abc123-1',
            title: 'Allow App to Track Location',
            taskType: DrillTaskType.ALLOW_LOCATION_PERMISSIONS,
            details: AllowLocationPermissionsDetails.example('abc123-1'),
          ),
          DrillTask(
            index: 2,
            taskID: 'abc123-2',
            title: 'Complete Pre-Drill Survey',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePre('Pre-Drill', 'abc123-2'),
          ),
          DrillTask(
            index: 3,
            taskID: 'abc123-3',
            title: 'Go to Drill Start Location',
            taskType: DrillTaskType.TRAVEL,
            details: TravelDetails.example(
              'Oceanside Beach State Park',
              'Go to Drill-Start Location',
              'abc123-3',
            ),
          ),
          DrillTask(
            index: 4,
            taskID: 'abc123-4',
            title: 'Acquire GPS prior to Drill Start',
            taskType: DrillTaskType.WAIT_FOR_START,
            details: WaitForStartDetails.example('abc123-4'),
          ),
          DrillTask(
            index: 5,
            taskID: 'abc123-5',
            title: 'Perform the Tsunami Evacuation Drill',
            taskType: DrillTaskType.PERFORM_DRILL,
            details: PerformDrillDetails.example('abc123-5'),
          ),
          DrillTask(
            index: 6,
            taskID: 'abc123-6',
            title: 'Complete Post-Drill Survey',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePost('Post-Drill', 'abc123-6'),
          ),
          DrillTask(
            index: 7,
            taskID: 'abc123-7',
            taskType: DrillTaskType.TRAVEL,
            title: 'Meet Researchers back at Post Office',
            details: TravelDetails.example(
              'Oceanside Post Office',
              'Regroup with Researchers',
              'abc123-7',
            ),
          ),
        ];

  DrillDetails.example2()
      : drillID = '123abc',
        inviteCode = '876542',
        title = 'Example Tsunami Evacuation Drill',
        meetingLocationPlainText = 'Oceanside, OR',
        meetingDateTime = DateTime.tryParse('2022-05-02T13:00:00.000001') ??
            null, // forced nullable on .tryParse(), need to handle...
        blurb =
            'Help us evaluate the current evacuation infrastructure of Oceanside!',
        description = null,
        publicKey = 'abc123',
        tasks = [
          DrillTask(
            index: 0,
            taskID: 'abc123-0',
            title: 'Allow App to Track Location',
            taskType: DrillTaskType.ALLOW_LOCATION_PERMISSIONS,
            details: AllowLocationPermissionsDetails.example('abc123-0'),
          ),
          DrillTask(
            index: 1,
            taskID: 'abc123-1',
            title: 'Complete Pre-Drill Survey',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePre('Pre-Drill', 'abc123-1'),
          ),
          DrillTask(
            index: 2,
            taskID: 'abc123-2',
            title: 'Acquire GPS prior to Drill Start',
            taskType: DrillTaskType.WAIT_FOR_START,
            details: WaitForStartDetails.example('abc123-2'),
          ),
          DrillTask(
            index: 3,
            taskID: 'abc123-3',
            title: 'Perform the Tsunami Evacuation Drill',
            taskType: DrillTaskType.PERFORM_DRILL,
            details: PerformDrillDetails.example('abc123-3'),
          ),
          DrillTask(
            index: 4,
            taskID: 'abc123-4',
            title: 'Complete Post-Drill Survey',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePost('Post-Drill', 'abc123-4'),
          ),
        ];

  DrillDetails.testTelemetry()
      : drillID = 'testTelemetry',
        inviteCode = '777777',
        title = 'Telemetry Test for Evac. Drill App',
        meetingLocationPlainText = 'San Diego, CA',
        meetingDateTime = DateTime.tryParse('2022-05-10T13:00:00.000001') ??
            null, // forced nullable on .tryParse(), need to handle...
        blurb = 'lettuce get this bread',
        description = null,
        publicKey = 'abc123',
        tasks = [
          DrillTask(
            index: 0,
            taskID: 'acq-telemetryTest',
            title: '"aCqUiRe GpS"',
            taskType: DrillTaskType.WAIT_FOR_START,
            details: WaitForStartDetails.example('acq-telemetryTest'),
          ),
          DrillTask(
            index: 1,
            taskID: 'perform-telemetryTest',
            title: 'Telemetry Test 🏃‍♂️',
            taskType: DrillTaskType.PERFORM_DRILL,
            details: PerformDrillDetails.example('perform-telemetryTest'),
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
    if (json['meetingDateTime'] != null) {
      try {
        meetingDateTime = DateTime.tryParse(json['meetingDateTime']);
      } catch (e) {
        throw Exception(
            'DrillDetails: could not parse meetingDatTime from json value:\n$e');
      }
      if (meetingDateTime == null) {
        throw Exception(
            'DrillDetails: could not parse meetingDatTime from json value');
      }
    }

    // // parse public key (why doesn't just loading in the string work??)
    // // not sure why, but this does work 🤔 🤷‍♂️ 👍
    // try {
    //   final newPublicKey = jsonDecode(json['publicKeyJSONString'])['publicKey'];
    //   print(newPublicKey);
    // } catch (e) {
    //   print(e);
    //   throw Exception();
    // }

    // return the actual object
    return DrillDetails(
      drillID: drillID, // fill in when parsing from Firestore
      inviteCode: json['inviteCode'],
      title: json['title'],
      meetingLocationPlainText: json['meetingLocationPlainText'],
      meetingDateTime: meetingDateTime,
      blurb: json['blurb'],
      description: json['description'],
      publicKey: jsonDecode(json['publicKeyJSONString'])['publicKey'],
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
      // 'drillID': drillID, // fill in when parsing from Firestore
      'inviteCode': inviteCode,
      'title': title,
      'meetingLocationPlainText': meetingLocationPlainText,
      'meetingDateTime': meetingDateTime?.toIso8601String(),
      'blurb': blurb,
      'description': description,
      'publicKeyJSONString': jsonEncode({"publicKey": publicKey}),
      'tasks': tasksJsonList,
    };
  }
}
