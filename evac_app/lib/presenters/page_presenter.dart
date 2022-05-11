import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evac_app/components/waves.dart';
import 'package:evac_app/models/drill_details/drill_details.dart';
import 'package:evac_app/models/drill_results/drill_results.dart';
import 'package:evac_app/pages/invite_code_page.dart';
import 'package:evac_app/pages/tasks_page.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

/// PagePresenter does just that: Present Pages!
///
/// We us PagePresenter to do the screen wipes with the dangerous element for a
/// given drill (right now, just waves for a tsunami drill. In the future, could
/// be flames for a fire drill, cracked earth for an earthquake drill, etc.).
///
/// PagePresenter presents FirstPage on load, then DrillPage once a user
/// confirms their participation in a drill.

class PagePresenter extends StatefulWidget {
  const PagePresenter({Key? key}) : super(key: key);

  @override
  State<PagePresenter> createState() => _PagePresenterState();
}

class _PagePresenterState extends State<PagePresenter> {
  static const _wavesDuration = const Duration(seconds: 2);

  bool _wavesUp = false;
  double _pageWavesHeightModifier = 1.0;
  bool wavesShowDrillDetails = false;

  late Widget pageContent;

  DrillDetails? _drillDetails;
  DrillResults? _drillResults;

  /// This function queries the server to determine if there is a DrillDetails
  /// object matching the provided invite code. If so, it loads it into state
  /// and returns true. If not, it returns false.
  Future<bool> tryInviteCode(String inputCode) async {
    Map<String, dynamic>? drillDetailsJson;
    String? _drillDetailsDocID;

    // check initial invite code against app Firebase Firestore
    // if invite code exists, extract the correlated DrillDetails Document ID
    bool valid = await FirebaseFirestore.instance
        .collection('DrillDetails')
        .where('inviteCode', isEqualTo: inputCode)
        .get()
        .then(
      (QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          DocumentSnapshot docSnapshot = querySnapshot.docs.first;
          if (docSnapshot.exists) {
            try {
              drillDetailsJson = docSnapshot.data() as Map<String, dynamic>;
              _drillDetailsDocID = docSnapshot.id;
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
      // translate from json to DrillDetails
      DrillDetails newDrillDetails =
          DrillDetails.fromJson(drillDetailsJson!, _drillDetailsDocID!);

      // store it in local state
      // and stop showing invite code page
      setState(() {
        _drillDetails = newDrillDetails;
        wavesShowDrillDetails = true;
      });

      // store it in persistent storage (async, don't await)

      // do rendering tasks
      onInviteCodeEntered();

      // return
      return true;
    } else {
      return false;
    }
  }

  /// This function does the rendering aspect of the "onInviteCodeEntered"
  /// event. At this point, the invite code should have been entered, validated,
  /// sent to server, validated serverside, and DrillDetails downloaded and put
  /// into state, so that the ConfrimDrillDetails widget will be passed the
  /// correct info.
  ///
  /// Currently it only does the rendering as we are not handling any
  /// DrillDetails objects yet.
  void onInviteCodeEntered() {
    setState(() {
      // make sure drill details show
      wavesShowDrillDetails = true;
    });
    // bring up waves
    toggleWavesUp();
  }

  Future<void> toggleWavesUp() async {
    setState(() {
      _wavesUp = !_wavesUp;
    });
    await Future.delayed(_wavesDuration);
    return;
  }

  void onDrillConfirmed() {
    setState(() {
      _drillResults = DrillResults(
          drillID: _drillDetails!.drillID,
          userID: Uuid().v4(),
          publicKey: _drillDetails!.publicKey);
      _pageWavesHeightModifier = 0.84;
      pageContent = TasksPage(
        exitDrill: exitDrill,
        drillDetails: _drillDetails!,
        drillResults: _drillResults!,
      );
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _wavesUp = false;
      });
    });
  }

  void exitDrill() {
    // make sure waves are only waves, not drill confirm dialog
    setState(() {
      wavesShowDrillDetails = false;
    });
    // bring waves up
    toggleWavesUp();
    // wait until done
    Future.delayed(_wavesDuration, () {
      setState(() {
        pageContent = InviteCodePage(tryInviteCode: tryInviteCode);
        _pageWavesHeightModifier = 1.0;
      });
      // bring the waves back down
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          _wavesUp = false;
        });
      });
    });
  }

  void onBackButtonPressed() {
    setState(() {
      _pageWavesHeightModifier = 1.0;
    });
  }

  @override
  void initState() {
    pageContent = InviteCodePage(
      tryInviteCode: tryInviteCode,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size pageSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          // the main content of the page
          pageContent,
          // the Waves are Animated and Positioned
          AnimatedPositioned(
            top: _wavesUp ? 0 : pageSize.height * _pageWavesHeightModifier,
            duration: const Duration(seconds: 2),
            curve: Curves.elasticOut,
            child: GestureDetector(
              onVerticalDragEnd: (_) async {
                if (pageContent.runtimeType == InviteCodePage) {
                  print('yuuuup');
                  await toggleWavesUp();
                  setState(() {
                    wavesShowDrillDetails = false;
                    _drillDetails = null;
                  });
                }
              },
              child: Waves(
                pageSize: pageSize,
                onDrillConfirmed: onDrillConfirmed,
                wavesShowDrillDetails: wavesShowDrillDetails,
                drillDetails: _drillDetails,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
