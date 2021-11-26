import 'package:evac_app/components/demos/v0_0_2/ui_ux_demo.dart';
import 'package:evac_app/components/demos/v0_0_3/confirm_drill.dart';
import 'package:evac_app/components/demos/v0_0_3/landing_page.dart';
import 'package:evac_app/components/demos/v0_0_3/pre_drill_survey.dart';
import 'package:evac_app/components/demos/v0_0_3/wait_screen.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

class RoughOutline extends StatefulWidget {
  const RoughOutline({Key? key}) : super(key: key);

  @override
  _RoughOutlineState createState() => _RoughOutlineState();
}

class _RoughOutlineState extends State<RoughOutline> {
  // I think that long-term the strategy here is to have an iterable that is toggled to the next thing instead of checking these state variables for non-nullity to know what to do next
  // I also think that there are examples to be reverse engineered within SurveyKit which address this. I also think that those examples rely on other packages like provider, bloc, etc.?

  String? _researcherFirestoreDetails = null;
  String? _drillEvent = null;
  bool? _confirmedDrill = null;
  SurveyResult? _preDrillResults = null;

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

        // probably need to reverse the order in which these appear for them to make sense (currently stacking later pages on top, doesn't really track...) see comments above about switching to an iterable state variable to decide page loaded
        if (_preDrillResults != null)
          MaterialPage(
            child: WaitScreen(),
          )
        else if (_confirmedDrill != null && _confirmedDrill!)
          MaterialPage(
            child: PreDrillSurvey(storePreDrillResults: storePreDrillResults),
            key: PreDrillSurvey.valueKey,
          )
        else if (_drillEvent != null)
          MaterialPage(
            child: ConfirmDrill(drillConfirmed: drillConfirmed),
            key: ConfirmDrill.valueKey,
          ),
      ],
      onPopPage: (route, result) {
        // final page = route.settings as MaterialPage;
        // if (page.key == LandingPage.valueKey) {}
        return route.didPop(result);
      },
    );
  }

  void syncDrillEvent() {
    // after succesfully entering invite code within last 24 hours this function should be called anytime state is being initialized (could be due to a close or crash of the app) to reset to the previous position and if on the "modified landing page" display the recently completed event
    if (!twiddleThumbs()!) {
      // store it in local state
      setState(() {
        _drillEvent = 'A placeholder for a DrillEvent object.';
      });
    }
    ;
  }

  Future<void> storePreDrillResults(SurveyResult result) async {
    // if (results is from completion, not exit)

    // store results in state
    setState(() {
      _preDrillResults = result;
    });
    // store results in persistent storage
    twiddleThumbs();
  }

  Future<void> drillConfirmed() async {
    // store results in state
    setState(() {
      _confirmedDrill = true;
    });
    // store results in persistent storage
    twiddleThumbs();
    // Contact firestore, create user entry.
  }

  Future<bool> getDrillEvent() async {
    if (_researcherFirestoreDetails != null) {
      // query the secondary Researcher Firestore for DrillEvent object
      twiddleThumbs();
      // store it in local state
      setState(() {
        _drillEvent = 'A placeholder for a DrillEvent object.';
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
