import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class AllowLocationPermissionsDisplay extends StatefulWidget {
  const AllowLocationPermissionsDisplay(
    this.topContext, {
    Key? key,
    required this.setLocationResult,
  }) : super(key: key);

  final BuildContext topContext;
  final Function setLocationResult;

  @override
  State<AllowLocationPermissionsDisplay> createState() =>
      _AllowLocationPermissionsDisplayState();
}

class _AllowLocationPermissionsDisplayState
    extends State<AllowLocationPermissionsDisplay> {
  late Widget dialogContent;

  @override
  void initState() {
    dialogContent = RequestPermissionDialogContent(onOk: onOk);
    super.initState();
  }

  void onOk() async {
    // change display to LoadingDialogContent
    setState(() {
      dialogContent = LoadingDialogContent();
    });

    // request location permission and handle possible results
    bool granted = await Permission.location.request().isGranted;

    if (granted) {
      bool grantedAndEnabled =
          await Permission.location.serviceStatus.isEnabled;
      if (grantedAndEnabled) {
        onFullPermissionReturn(grantedAndEnabled);
      }
    } else {
      // set result to false
      widget.setLocationResult(false);

      // notify user their location services are turned off.
      setState(() {
        dialogContent = NotifyLocationServiceOffDialogContent();
      });
    }
    // .then(result => onPermissionReturn(result))
  }

  void onFullPermissionReturn(bool grantedAndEnabled) async {
    if (grantedAndEnabled) {
      // show confirmation
      setState(() {
        dialogContent = PermissionGrantedDialogContent();
      });

      // set result to true
      widget.setLocationResult(true);

      // wait 1.8 seconds
      await Future.delayed(Duration(milliseconds: 1800));

      // pop
      Navigator.pop(widget.topContext, true);
    } else {
      // set result to false
      widget.setLocationResult(false);

      // show notification
      setState(() {
        dialogContent = NotifyNoPermissionDialogContent();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: dialogContent);
  }
}

class RequestPermissionDialogContent extends StatelessWidget {
  const RequestPermissionDialogContent({Key? key, required this.onOk})
      : super(key: key);

  final Function onOk;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.location,
          size: 128,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          'Allow us to track your location?',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'One of the purposes of this drill is for Civil Engineering Researchers to gather data. You can generate the most value for your Drill Coordinators if you allow your location to be tracked while you perform you drill.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        CupertinoButton.filled(
          child: Text('Ok'),
          onPressed: () {
            onOk();
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class LoadingDialogContent extends StatelessWidget {
  const LoadingDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: SizedBox(
            child: CupertinoActivityIndicator(
              radius: 64,
            ),
            height: 128,
            width: 128,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'loading…',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class PermissionGrantedDialogContent extends StatelessWidget {
  const PermissionGrantedDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.check_mark_circled,
          size: 128,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          'Thanks!',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'We will track your location while you perform your drill.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class NotifyNoPermissionDialogContent extends StatelessWidget {
  const NotifyNoPermissionDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.nosign,
          size: 128,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          'Location Permissions Denied.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'We understand, and will not track your location.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'If you change your mind, please go to you phone\'s settings and allow location permissions for our app, then re-complete this task.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        CupertinoButton.filled(
          child: Text('Ok'),
          onPressed: () {
            // popping and returning false as we do not have permission to track location
            Navigator.pop(context, false);
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}

class NotifyLocationServiceOffDialogContent extends StatelessWidget {
  const NotifyLocationServiceOffDialogContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          CupertinoIcons.nosign,
          size: 128,
          color: Colors.black,
        ),
        SizedBox(height: 20),
        Text(
          'Location Services Currently Disabled.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 36,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),
        Text(
          'Thanks for giving us permission to track your location!',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Unfortunately, location services are currently disabled on your device.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Please go to your Settings to enable location services, then re-complete this task.',
          style: GoogleFonts.getFont(
            'Roboto',
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 12),
        CupertinoButton.filled(
          child: Text('Ok'),
          onPressed: () {
            // popping and returning false as we do not have full permission to track location (due to location service being turned off)
            Navigator.pop(context, false);
          },
        ),
      ],
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }
}
