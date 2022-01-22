import 'package:evac_app/components/demos/v0_0_3/confirm_drill.dart';
import 'package:evac_app/components/demos/v0_0_3/during_drill.dart';
import 'package:evac_app/components/demos/v0_0_3/landing_page.dart';
import 'package:evac_app/components/demos/v0_0_3/pre_drill_survey.dart';
import 'package:evac_app/components/demos/v0_0_3/wait_screen.dart';
import 'package:evac_app/models/drill_event.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class RoughOutline extends StatefulWidget {
  const RoughOutline({Key? key}) : super(key: key);

  @override
  _RoughOutlineState createState() => _RoughOutlineState();
}

class _RoughOutlineState extends State<RoughOutline> {
  String? _researcherFirestoreDetails = null;
  DrillEvent? _drillEvent = null;
  bool? _confirmedDrill = null;
  SurveyResult? _preDrillResults = null;
  bool? _researcherStartReceived = null;

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
        if (_drillEvent != null)
          MaterialPage(
            child: ConfirmDrill(),
            key: ConfirmDrill.valueKey,
          )
        else if (_confirmedDrill != null &&
            _confirmedDrill! &&
            _preDrillResults == null)
          MaterialPage(
            child: PreDrillSurvey(),
            key: PreDrillSurvey.valueKey,
          )
        else if (_preDrillResults != null)
          MaterialPage(
            child: WaitScreen(),
          )
        else if (_researcherStartReceived != null && _researcherStartReceived!)
          MaterialPage(
            child: DuringDrill(),
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
        }

        return route.didPop(result);
      },
    );
  }

  void syncDrillEvent() {
    // after succesfully entering invite code within last 24 hours this function should be called anytime state is being initialized (could be due to a close or crash of the app) to reset to the previous position and if on the "modified landing page" display the recently completed event
    if (!twiddleThumbs()!) {
      // store it in local state
      setState(() {
        _drillEvent = DrillEvent.example();
      });
    }
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
