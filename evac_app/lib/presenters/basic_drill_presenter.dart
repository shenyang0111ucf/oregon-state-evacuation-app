import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/gpx_export/results_exporter.dart';
import 'package:evac_app/location_tracking/location_tracker.dart';
import 'package:evac_app/models/drill_result.dart';
import 'package:evac_app/pages/confirm_drill.dart';
import 'package:evac_app/pages/during_drill.dart';
import 'package:evac_app/pages/invite_code_page.dart';
import 'package:evac_app/pages/landing_page.dart';
import 'package:evac_app/pages/post_drill_survey.dart';
import 'package:evac_app/pages/pre_drill_survey.dart';
import 'package:evac_app/pages/wait_screen.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class BasicDrillPresenter extends StatefulWidget {
  const BasicDrillPresenter({Key? key}) : super(key: key);

  @override
  _BasicDrillPresenterState createState() => _BasicDrillPresenterState();
}

class _BasicDrillPresenterState extends State<BasicDrillPresenter> {
  bool _tryingInviteCode = false;
  DrillEvent? _drillEvent = null;
  bool? _confirmedDrill = null;
  String? _drillEventDocID = null;
  String? _userID = null;
  DrillResult? _drillResult = null;
  bool _researcherStartReceived = false;
  bool _drillComplete = false;

  LocationTracker? locTracker;
  String filename = 'abc123-2022-02-20T144003';

  // fake _preDrillResults, uncomment to skip to DuringDrill in app flow
  // SurveyResult? _preDrillResults = SurveyResult(
  //     id: Identifier(id: 'blah'),
  //     startDate: DateTime.now(),
  //     endDate: DateTime.now(),
  //     finishReason: FinishReason.COMPLETED,
  //     results: []);

  @override
  void initState() {
    super.initState();
    syncDrillEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [
        MaterialPage(
          child: LandingPage(pushInviteCodePage: pushInviteCodePage),
          key: LandingPage.valueKey,
        ),
        if (_drillComplete)
          MaterialPage(
            child: PostDrillSurvey(drillEvent: _drillEvent!),
            key: PostDrillSurvey.valueKey,
          )
        else if (_researcherStartReceived)
          MaterialPage(
            child: DuringDrill(drillEvent: _drillEvent!),
            key: DuringDrill.valueKey,
          )
        else if (_drillResult != null && _drillResult!.hasPreDrillResult())
          MaterialPage(
            child: WaitScreen(),
          )
        else if (_confirmedDrill != null &&
            _confirmedDrill! &&
            (_drillResult == null ||
                (_drillResult != null && !_drillResult!.hasPreDrillResult())))
          MaterialPage(
            child: PreDrillSurvey(drillEvent: _drillEvent!),
            key: PreDrillSurvey.valueKey,
          )
        else if (_drillEvent != null)
          MaterialPage(
            child: ConfirmDrill(drillEvent: _drillEvent!),
            key: ConfirmDrill.valueKey,
          )
        else if (_tryingInviteCode)
          MaterialPage(
            child: InviteCodePage(tryInviteCode: tryInviteCode),
            key: InviteCodePage.valueKey,
          ),
      ],
      onPopPage: (route, result) {
        final page = route.settings as MaterialPage;

        if (page.key == InviteCodePage.valueKey) {
          setState(() {
            _tryingInviteCode = false;
          });
        }

        // if returning from ConfirmDrill Page
        if (page.key == ConfirmDrill.valueKey) {
          if (result) {
            setState(() {
              _confirmedDrill = result;
              _drillResult = DrillResult();
            });

            // store results in persistent storage
            twiddleThumbs();

            // Contact firestore, create user entry.
            _userID = Uuid().v4();
            addUser();
          } else {
            setState(() {
              _drillEvent = null;
            });
          }
        }

        if (page.key == PreDrillSurvey.valueKey) {
          // check if (results is from completion, not exit)

          // store results in state
          // change to storing in DrillEvent object?
          setState(() {
            // _preDrillResults = result;
            _drillResult!.addSurveyResult(result);
          });

          print(_drillResult!.hasPreDrillResult());

          // store results in persistent storage
          twiddleThumbs();

          // choose between "your drill starts in [x time]" page and "waiting for drill to start"
          // if "waiting for drill to start" then start listening for signal from researcher
          listenForStartSignal();
        }

        if (page.key == DuringDrill.valueKey) {
          // stop tracking location
          locTracker!.stopLogging().then((_) {
            setState(() {
              locTracker = null;
            });
          });
          // do any storage after drill
          if (result) {
            setState(() {
              _drillComplete = result;
            });
            // export
            _drillResult!.addGpxFile(locTracker!.createTrajectory(filename));
          } else {
            setState(() {
              _researcherStartReceived = false;
              // _preDrillResults = null;
              _drillResult = null;
              _confirmedDrill = null;
              _drillEvent = null;
            });
            // right now we are throwing away any results if they back out. In the future we should have much more complex location logging, with pause+resume, etc.
          }
        }

        if (page.key == PostDrillSurvey.valueKey) {
          if (result != null) {
            // store this survey result
            _drillResult!.addSurveyResult(result);

            // store all results
            // export
            final exporter = ResultsExporter(
                drillEventID: _drillEvent!.id,
                publicKey: _drillEvent!.publicKey,
                drillResult: _drillResult!,
                userID: _userID!);
            exporter.export();

            // reset state
            setState(() {
              _drillEvent = null;
              _confirmedDrill = null;
              _drillResult = null;
              _researcherStartReceived = false;
              _drillComplete = false;
            });
          }
        }

        return route.didPop(result);
      },
    );
  }

  void syncDrillEvent() {
    // after succesfully entering invite code within last 24 hours this function should be called anytime state is being initialized (could be due to a close or crash of the app) to reset to the previous position and if on the "modified landing page" display the recently completed event

    // if choosing to store survey results elsewhere, sync those as well

    if (!twiddleThumbs()!) {
      // store it in local state
      setState(() {
        _drillEvent = DrillEvent.example();
      });
    }
  }

  void listenForStartSignal() async {
    // listen
    bool startSignal = await Future.delayed(
      Duration(seconds: 3),
      () {
        return true;
      },
    );
    // tell DrillPresenter signal arrived
    setState(() {
      _researcherStartReceived = startSignal;
    });
    // start tracking location
    locTracker = LocationTracker();
    locTracker!.startLogging();
  }

  Future<bool> addUser() async {
    // query Firebase to add user to DrillEvent.participants
    return FirebaseFirestore.instance
        .collection('DrillEvents')
        .doc(_drillEventDocID)
        .collection('participants')
        .add({
          'uuid': _userID,
          'completed': false,
        })
        .then((value) => true)
        .catchError((error) {
          _userID = Uuid().v4();
          addUser();
          return false;
        });
  }

  Future<bool> getDrillEvent(documentID) async {
    String? drillEventJson;

    // query Firebase for DrillEvent json string
    bool gotJson = await FirebaseFirestore.instance
        .collection('DrillEvents')
        .doc(documentID)
        .get()
        .then((DocumentSnapshot docSnapshot) {
      if (docSnapshot.exists) {
        try {
          var docData = docSnapshot.data() as Map<String, dynamic>;
          drillEventJson = docData['drillEventJson'];
          print('obtained DrillEvent json string from firebase');
          return true;
        } on Exception catch (e) {
          print(e);
          return false;
        }
      }
      print('DrillEvent json string not in firebase');
      return false;
    });

    if (gotJson) {
      // translate from string to DrillEvent
      DrillEvent newDrillEvent =
          DrillEvent.fromJson(jsonDecode(drillEventJson!));

      // store it in local state
      // and stop showing invite code page
      setState(() {
        _drillEvent = newDrillEvent;
        // _drillEvent = DrillEvent.example();
        _tryingInviteCode = false;
      });

      // store it in persistent storage (async, don't await)
      twiddleThumbs();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> tryInviteCode(inputCode) async {
    String? drillEventDocID;

    // check initial invite code against app Firebase Firestore
    // if invite code exists, extract the correlated DrillEvent Document ID
    bool valid = await FirebaseFirestore.instance
        .collection('InviteCodes')
        .where('inviteCode', isEqualTo: inputCode)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;
          if (docSnapshot.exists) {
            try {
              var docData = docSnapshot.data() as Map<String, dynamic>;
              drillEventDocID = docData['drillEventDocID'];
              print('invite code in firebase');
              return true;
            } on Exception catch (e) {
              print(e);
              return false;
            }
          }
        }
        print('invite code not in firebase');
        return false;
      },
    );

    if (valid) {
      _drillEventDocID = drillEventDocID;
      await getDrillEvent(drillEventDocID);
      return true;
    } else {
      return false;
    }
  }

  void pushInviteCodePage() {
    setState(() {
      _tryingInviteCode = true;
    });
  }

  bool? twiddleThumbs() => true;
}
