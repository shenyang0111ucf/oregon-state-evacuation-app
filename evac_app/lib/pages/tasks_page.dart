import 'package:evac_app/components/utility/gradient_background_container.dart';
import 'package:evac_app/components/utility/styled_alert_dialog.dart';
import 'package:evac_app/components/utility/styled_dialog.dart';
import 'package:evac_app/extra_dialog_contents/wait_first_dialog_content.dart';
import 'package:evac_app/models/drill_details/drill_details.dart';
import 'package:evac_app/models/drill_details/drill_details_type_enums.dart';
import 'package:evac_app/models/drill_details/drill_tasks/drill_task.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/allow_location_permissions_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/perform_drill_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/survey_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/travel_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/upload_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_details/wait_for_start_details.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/allow_location_permissions_result.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/perform_drill_result.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/survey_task_result.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/travel_result.dart';
import 'package:evac_app/models/drill_details/drill_tasks/task_results/wait_for_start_result.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';
import 'package:evac_app/task_displays/allow_location_permissions_display.dart';
import 'package:evac_app/task_displays/perform_drill_display.dart';
import 'package:evac_app/task_displays/survey_display.dart';
import 'package:evac_app/task_displays/travel_display.dart';
import 'package:evac_app/task_displays/upload_display.dart';
import 'package:evac_app/task_displays/wait_for_start_display.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({
    Key? key,
    required this.exitDrill,
    required this.drillDetails,
    required this.drillResults,
  }) : super(key: key);

  final Function exitDrill;
  final DrillDetails drillDetails;
  final DrillResults drillResults;

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late List<DrillTask> tasks;

  @override
  void initState() {
    super.initState();
    tasks = widget.drillDetails.tasks +
        [
          DrillTask(
              index: widget.drillDetails.tasks.length + 1,
              taskID: 'upload_ID',
              taskType: DrillTaskType.UPLOAD,
              title: 'Complete Drill and Upload Results',
              details: UploadDetails())
        ];
  }

  @override
  Widget build(BuildContext context) {
    // if (allTasksHaveResults()) {
    //   bool showUploadDialog = true
    // }

    return GradientBackgroundContainer(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 4.0),
                  child: Text(
                    widget.drillDetails.title,
                    style: GoogleFonts.getFont(
                      'Open Sans',
                      color: Colors.white.withAlpha(218),
                      fontWeight: FontWeight.w800,
                      fontSize: 32,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return ListView(
                    children: <Widget>[
                          Stack(
                            children: [
                              Align(
                                alignment: Alignment(0.0, -0.05),
                                child: SizedBox(
                                  height: 215,
                                  width: 230,
                                  child: SvgPicture.asset(
                                    'assets/icons/OSU_icon_ClipBoard.svg',
                                    fit: BoxFit.fitWidth,
                                    color: Colors.white.withAlpha(218),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 215,
                                    ),
                                    Text(
                                      'Drill Tasks',
                                      style: GoogleFonts.getFont(
                                        'Open Sans',
                                        color: Colors.white.withAlpha(218),
                                        fontWeight: FontWeight.w800,
                                        fontSize: 42,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 280),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Text(
                          //     'Drill Tasks:',
                          //     style: GoogleFonts.getFont(
                          //       'Open Sans',
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.w700,
                          //       fontSize: 16,
                          //       // decoration: TextDecoration()
                          //     ),
                          //     textAlign: TextAlign.right,
                          //   ),
                          // ),
                        ] +
                        generateTaskButtonList(setState) +
                        <Widget>[SizedBox(height: 78)],
                  );
                }))
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StyledAlertDialog(
                            context: context,
                            title: 'Wait!',
                            subtitle:
                                'Are you sure that you want to exit the drill early? This action cannot be undone.',
                            cancelText: 'Continue Drill',
                            cancelFunc: () {
                              Navigator.pop(context);
                            },
                            confirmText: 'Exit Drill',
                            confirmFunc: () async {
                              // gather and save results
                              // TODO: implement function which saves partial results
                              // TODO: prompt user to upload partial results?
                              // pop this dialog
                              Navigator.pop(context);
                              // pop drill page
                              widget.exitDrill();
                            });
                      });
                },
                child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(children: [
                      Icon(CupertinoIcons.back,
                          size: 32, color: Colors.white.withAlpha(142)),
                      // SizedBox(width: 4),
                      // Text(
                      //   'Tasks',
                      //   style: GoogleFonts.getFont(
                      //     'Open Sans',
                      //     color: Colors.white,
                      //     fontWeight: FontWeight.w500,
                      //     fontSize: 18,
                      //   ),
                      // )
                    ])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> generateTaskButtonList(Function setState) {
    return List.generate(
        tasks.length,
        (index) => Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ExpansionTileCard(
                initiallyExpanded: false,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 20.0, right: 20.0),
                    child: Text(
                      getTaskDescription(tasks[index]),
                      style: GoogleFonts.getFont(
                        'Open Sans',
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withAlpha(51),
                                  blurRadius: 6,
                                  offset: Offset(0, 2))
                            ]),
                        child: CupertinoButton.filled(
                          borderRadius: BorderRadius.circular(10),
                          child: Text(
                            'Start Task',
                            style: GoogleFonts.openSans(),
                          ),
                          onPressed:
                              getButtonFunction(context, index, setState),
                        ),
                      ),
                    ),
                  )
                ],
                initialElevation: 4.0,
                elevation: 8.0,
                leading: (thisTaskDone(tasks[index]))
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(CupertinoIcons.checkmark_circle_fill, size: 30)
                          ])
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(CupertinoIcons.circle, size: 30)]),
                title: Text(
                  tasks[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.getFont(
                    'Open Sans',
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'expand for details',
                  style: GoogleFonts.getFont(
                    'Open Sans',
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                ),
              ),
            ));
  }

  bool thisTaskDone(DrillTask task) {
    if (task.taskType == DrillTaskType.UPLOAD) {
      return false;
    }
    var foundMatch = false;
    var matchingResult;
    for (var result in widget.drillResults.taskResults) {
      if (result.taskID() == task.taskID) {
        foundMatch = true;
        matchingResult = result;
        break;
      }
    }
    if (foundMatch) {
      switch (task.taskType) {
        case DrillTaskType.SURVEY:
          final result = matchingResult as SurveyTaskResult;
          return result.completed;
        case DrillTaskType.ALLOW_LOCATION_PERMISSIONS:
          return true;
        case DrillTaskType.WAIT_FOR_START:
          final result = matchingResult as WaitForStartResult;
          return result.complete;
        case DrillTaskType.PERFORM_DRILL:
          final result = matchingResult as PerformDrillResult;
          return result.completed;
        case DrillTaskType.TRAVEL:
          return true;
        case DrillTaskType.UPLOAD:
          break;
      }
    }
    return false;
  }

  void Function() getButtonFunction(
      BuildContext context, int index, Function setState) {
    DrillTask drillTask = tasks[index];
    switch (drillTask.taskType) {
      case DrillTaskType.SURVEY:
        return _makeSurveyButtonFunction(context, drillTask.details, setState);
      case DrillTaskType.ALLOW_LOCATION_PERMISSIONS:
        return _makeAllowLocPermButtonFunction(
            context, drillTask.details, setState);
      case DrillTaskType.WAIT_FOR_START:
        return _makeWaitForStartButtonFunction(
            context, drillTask.details, tasks[index + 1].details, setState);
      case DrillTaskType.PERFORM_DRILL:
        return _makePerformDrillButtonFunction(
            context, tasks[index - 1].details);
      case DrillTaskType.TRAVEL:
        return _makeTravelButtonFunction(context, drillTask.details, setState);
      case DrillTaskType.UPLOAD:
        return _makeUploadButtonFunction(context);
    }
  }

  void Function() _makeUploadButtonFunction(BuildContext context) {
    void _uploadButtonFunction() {
      // show dialog prompting results upload
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return StyledDialog(
            child: UploadDisplay(
              topContext: context,
              drillResults: widget.drillResults,
              exitDrill: widget.exitDrill,
            ),
          );
        },
      );
    }

    return _uploadButtonFunction;
  }

  void Function() _makeSurveyButtonFunction(
      BuildContext context, TaskDetails details, Function setState) {
    void _surveyButtonFunction() {
      // get the survey details
      final surveyTaskDetails = details as SurveyDetails;

      // Navigator.push SurveyDisplay route
      Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) =>
              // need to add back/exit button!!!
              WillPopScope(
            onWillPop: () async => false,
            child: SurveyDisplay(
              surveyTaskDetails: surveyTaskDetails,
              setSurveyTaskResult: makeSurveyTaskResultSetter(
                  widget.drillResults, surveyTaskDetails, setState),
            ),
          ),
        ),
      );
    }

    return _surveyButtonFunction;
  }

  void Function() _makeAllowLocPermButtonFunction(
      BuildContext topContext, TaskDetails details, Function setState) {
    void _allowLocPermButtonFunction() {
      final taskDetails = details as AllowLocationPermissionsDetails;

      // On TaskButton press: show the appropriate dialog
      showDialog(
        context: topContext,
        builder: (BuildContext context) {
          return StyledDialog(
            child: AllowLocationPermissionsDisplay(
              topContext,
              setLocationResult: makeALPResultSetter(
                  widget.drillResults, taskDetails, setState),
            ),
          );
        },
      );
    }

    return _allowLocPermButtonFunction;
  }

  void Function() _makeWaitForStartButtonFunction(BuildContext context,
      TaskDetails waitDetails, TaskDetails performDetails, Function setState) {
    void _waitForStartButtonFunction() {
      // get the PerformDrillDetails from DrillDetails
      final performDrillDetails = performDetails as PerformDrillDetails;

      // create the function which will be called inside WaitForStartDisplay that
      // pushes the PerformDrillDisplay
      void pushPerformDrill() {
        // Navigator.push PerformDrill route
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) =>
                // need to add back/exit button!!!
                PerformDrillDisplay(
              performDrillDetails: performDrillDetails,
              userID: widget.drillResults.userID,
              setPerformDrillResult: makePerformDrillResultSetter(
                  widget.drillResults, performDrillDetails, setState),
            ),
          ),
        );
      }

      // get the PerformDrillDetails from DrillDetails
      final waitForStartDetails = waitDetails as WaitForStartDetails;

      // create Wait For Start Widget tree (start w Scaffold, no app bar)
      // Navigator.push WaitForStartDisplay route
      Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) =>
              // need to add back/exit button!!!
              WaitForStartDisplay(
                  pushPerformDrill: pushPerformDrill,
                  setWaitForStartResult: makeWaitForStartResultSetter(
                      widget.drillResults, waitForStartDetails, setState)),
        ),
      );
    }

    return _waitForStartButtonFunction;
  }

  void Function() _makePerformDrillButtonFunction(
      BuildContext topContext, TaskDetails waitDetails) {
    void _performDrillButtonFunction() {
      // get the WaitForStart taskTitle
      String taskTitle;
      final waitForStartDetails = waitDetails as WaitForStartDetails;
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

    return _performDrillButtonFunction;
  }

  void Function() _makeTravelButtonFunction(
      BuildContext context, TaskDetails details, Function setState) {
    void _travelButtonFunction() {
      // get the Travel details
      final travelDetails = details as TravelDetails;
      // Navigator.push Travel route
      Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) =>
              // need to add back/exit button!!!
              TravelDisplay(
            travelDetails: travelDetails,
            setTravelResult: makeTravelResultSetter(
                widget.drillResults, travelDetails, setState),
          ),
        ),
      );
    }

    return _travelButtonFunction;
  }
}

String getTaskDescription(DrillTask task) {
  switch (task.taskType) {
    case DrillTaskType.SURVEY:
      return 'This task is a series of questions, of which your answers will be recorded. Questions include previous drill & evacuation experience, as well as demographic information.';
    case DrillTaskType.ALLOW_LOCATION_PERMISSIONS:
      return 'This task requests location permissions on your device in order to generate valuable datasets for evacuation traffic researchers. Your results will be anonymized and encrypted-at-rest.';
    case DrillTaskType.WAIT_FOR_START:
      return 'This task ensures you and your device are prepared to perform the Evacuation Drill.';
    case DrillTaskType.PERFORM_DRILL:
      return 'This is the main event – the Evacuation Drill! But be sure to do the task above first!';
    case DrillTaskType.TRAVEL:
      return 'This task requires you to travel to a new location, in preparation for a future task.';
    case DrillTaskType.UPLOAD:
      return 'This task allows you to complete your Evacuation Drill Participation, and upload any results you generated to you Drill Coordinator.';
  }
}
