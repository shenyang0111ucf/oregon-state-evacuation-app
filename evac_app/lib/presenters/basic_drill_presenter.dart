import 'package:evac_app/pages/confirm_drill.dart';
import 'package:evac_app/pages/during_drill.dart';
import 'package:evac_app/pages/landing_page.dart';
import 'package:evac_app/pages/post_drill_survey.dart';
import 'package:evac_app/pages/pre_drill_survey.dart';
import 'package:evac_app/pages/wait_screen.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class BasicDrillPresenter extends StatefulWidget {
  const BasicDrillPresenter({Key? key}) : super(key: key);

  @override
  _BasicDrillPresenterState createState() => _BasicDrillPresenterState();
}

class _BasicDrillPresenterState extends State<BasicDrillPresenter> {
  String? _researcherFirestoreDetails = null;
  DrillEvent? _drillEvent = null;
  bool? _confirmedDrill = null;
  SurveyResult? _preDrillResults = null;
  bool _researcherStartReceived = false;
  bool _drillComplete = false;

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
          child: LandingPage(tryInviteCode: tryInviteCode),
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
        else if (_preDrillResults != null)
          MaterialPage(
            child: WaitScreen(),
          )
        else if (_confirmedDrill != null &&
            _confirmedDrill! &&
            _preDrillResults == null)
          MaterialPage(
            child: PreDrillSurvey(drillEvent: _drillEvent!),
            key: PreDrillSurvey.valueKey,
          )
        else if (_drillEvent != null)
          MaterialPage(
            child: ConfirmDrill(),
            key: ConfirmDrill.valueKey,
          ),
      ],
      onPopPage: (route, result) {
        final page = route.settings as MaterialPage;

        // if returning from ConfirmDrill Page
        if (page.key == ConfirmDrill.valueKey) {
          setState(() {
            _confirmedDrill = result;
          });

          // store results in persistent storage
          twiddleThumbs();

          // Contact firestore, create user entry.
          twiddleThumbs();
        }

        if (page.key == PreDrillSurvey.valueKey) {
          // check if (results is from completion, not exit)

          // store results in state
          // change to storing in DrillEvent object?
          setState(() {
            _preDrillResults = result;
          });

          // store results in persistent storage
          twiddleThumbs();

          // choose between "your drill starts in [x time]" page and "waiting for drill to start"
          // if "waiting for drill to start" then start listening for signal from researcher
          listenForStartSignal();
        }

        if (page.key == DuringDrill.valueKey) {
          // do any storage after drill

          setState(() {
            _drillComplete = result;
          });
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
      Duration(seconds: 8),
      () {
        return true;
      },
    );
    // tell DrillPresenter signal arrived
    setState(() {
      _researcherStartReceived = startSignal;
    });
  }

  Future<bool> getDrillEvent() async {
    if (_researcherFirestoreDetails != null) {
      // query the secondary Researcher Firestore for DrillEvent object
      twiddleThumbs();

      // store it in local state
      setState(() {
        _drillEvent = DrillEvent.example();
      });

      // store it in persistent storage
      twiddleThumbs();
      return true;
    }
    return false;
  }

  Future<bool> tryInviteCode() async {
    /// "query firestore for second firestore details"
    /// "save second firestore details in volatile state"

    // check initial invite code against app Firebase Firestore
    bool valid = twiddleThumbs()!;

    if (valid) {
      // request the secondary Researcher Firestore details
      var firestoreDetails = twiddleThumbs().toString();
      // store result in state
      _researcherFirestoreDetails = firestoreDetails;
      // async get drill event from newly discovered firestore
      getDrillEvent();
      return true;
    } else {
      return false;
    }
  }

  bool? twiddleThumbs() => true;
}
