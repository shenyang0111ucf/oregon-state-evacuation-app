import 'package:evac_app/components/utility/styled_dialog.dart';
import 'package:evac_app/extra_dialog_contents/wait_first_dialog_content.dart';
import 'package:evac_app/models/drill_details/drill_details.dart';
import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/allow_location_permissions_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/perform_drill_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/survey_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/travel_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/wait_for_start_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/allow_location_permissions_result.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/task_result.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';
import 'package:evac_app/task_displays/allow_location_permissions_display.dart';
import 'package:evac_app/task_displays/perform_drill_display.dart';
import 'package:evac_app/task_displays/survey_display.dart';
import 'package:evac_app/task_displays/travel_display.dart';
import 'package:evac_app/task_displays/wait_for_start_display.dart';
import 'package:flutter/material.dart';

class TaskDisplayExperiment extends StatefulWidget {
  TaskDisplayExperiment({Key? key}) : super(key: key);
  final drillDetails = DrillDetails.example();

  @override
  State<TaskDisplayExperiment> createState() => _TaskDisplayExperimentState();
}

class _TaskDisplayExperimentState extends State<TaskDisplayExperiment> {
  late DrillResults drillResults;

  @override
  void initState() {
    drillResults = DrillResults(
        drillID: widget.drillDetails.drillID, userID: 'exampleUserID');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size pageSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.deepOrange[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text('Survey'),
              onPressed: () {
                _surveyButtonFunction(context);
              },
            ),
            OutlinedButton(
              child: Text('Allow Location Permissions'),
              onPressed: () {
                final allowLocPermTaskDetails = widget.drillDetails.tasks[1]
                    .details as AllowLocationPermissionsDetails;
                _allowLocPermButtonFunction(context, allowLocPermTaskDetails);
              },
            ),
            OutlinedButton(
              child: Text('Wait for Start'),
              onPressed: () {
                _waitForStartButtonFunction(context);
              },
            ),
            OutlinedButton(
              child: Text('Perform Drill'),
              onPressed: () {
                _performDrillButtonFunction(context);
              },
            ),
            OutlinedButton(
              child: Text('Travel'),
              onPressed: () {
                _travelButtonFunction(context);
              },
            ),
            // OutlinedButton(
            //   child: Text('Upload Example DrillDetails'),
            //   onPressed: () {
            //     _uploadExampleDrillDetails(context);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  void _surveyButtonFunction(BuildContext context) {
    // get the survey details
    final surveyTaskDetails =
        widget.drillDetails.tasks[2].details as SurveyDetails;

    // Navigator.push SurveyDisplay route
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            // need to add back/exit button!!!
            SurveyDisplay(surveyTaskDetails: surveyTaskDetails),
      ),
    );
  }

  void _allowLocPermButtonFunction(
      BuildContext topContext, AllowLocationPermissionsDetails taskDetails) {
    ///
    /// This function handles the results of the AllowLocationPermissions task.
    ///
    void setLocationResult(bool result) {
      // find out if there is already an `AllowLocationPermissionsResult` in `drillResults`
      bool haveAllowLocPermResult = false;
      int? indexOfAllowLocPermRes;
      int index = 0;
      for (TaskResult taskResult in drillResults.taskResults) {
        if (taskResult.taskType == DrillTaskType.ALLOW_LOCATION_PERMISSIONS) {
          haveAllowLocPermResult = true;
          indexOfAllowLocPermRes = index;
          break;
        }
        index++;
      }

      // If there isn't a result yet, add one
      if (!haveAllowLocPermResult) {
        drillResults.taskResults.add(
          AllowLocationPermissionsResult(
            taskID: taskDetails.taskID,
            allowed: result,
          ),
        );
      }

      // otherwise, overwrite the one we already have
      else {
        if (indexOfAllowLocPermRes == null) {
          throw Exception(
              'AllowLocation…Result: How did we not have an index set if there is already a result?');
        }
        drillResults.taskResults[indexOfAllowLocPermRes] =
            AllowLocationPermissionsResult(
          taskID: taskDetails.taskID,
          allowed: result,
        );
      }
    }

    // do the actual button thing
    showDialog(
      context: topContext,
      builder: (BuildContext context) {
        return StyledDialog(
          child: AllowLocationPermissionsDisplay(
            topContext,
            setLocationResult: setLocationResult,
          ),
        );
      },
    );
  }

  void _waitForStartButtonFunction(BuildContext context) {
    void pushPerformDrill() {
      // get the PerformDrillDetails from DrillDetails
      final performDrillDetails =
          widget.drillDetails.tasks[5].details as PerformDrillDetails;
      // Navigator.push PerformDrill route
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) =>
              // need to add back/exit button!!!
              PerformDrillDisplay(
            performDrillDetails: performDrillDetails,
            userID: drillResults.userID,
          ),
        ),
      );
    }

    // create Wait For Start Widget tree (start w Scaffold, no app bar)
    // Navigator.push WaitForStartDisplay route
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            // need to add back/exit button!!!
            WaitForStartDisplay(pushPerformDrill: pushPerformDrill),
      ),
    );
  }

  void _performDrillButtonFunction(BuildContext topContext) {
    // get the WaitForStart taskTitle
    String taskTitle;
    final waitForStartDetails =
        widget.drillDetails.tasks[4].details as WaitForStartDetails;
    switch (waitForStartDetails.typeOfWait) {
      case TypeOfWait.SELF:
        taskTitle = 'Acquire GPS Signal before Performing Drill';
        break;
      default:
        taskTitle = 'Wait for Drill to Begin';
        break;
    }

    // do the actual button thing
    showDialog(
      context: topContext,
      builder: (BuildContext context) {
        return StyledDialog(
          child: WaitFirstDialogContent(
            topContext,
            taskTitle: taskTitle,
          ),
        );
      },
    );
  }

  void _travelButtonFunction(BuildContext context) {
    // get the Travel details
    final travelDetails = widget.drillDetails.tasks[3].details as TravelDetails;
    // Navigator.push Travel route
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) =>
            // need to add back/exit button!!!
            TravelDisplay(travelDetails),
      ),
    );
  }

  // void _uploadExampleDrillDetails(BuildContext context) async {
  //   bool valid = await FirebaseFirestore.instance
  //       .collection('DrillDetails')
  //       .doc('ij72tkfHQFBMDe7niLwn')
  //       .set(DrillDetails.example().toJson())
  //       .then((value) {
  //     return true;
  //   }).catchError((error) {
  //     print(error);
  //     return false;
  //   });
  //   ;
  //   if (valid) {
  //   } else {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(SnackBar(content: Text('dangit 🤡')));
  //   }
  // }
}
