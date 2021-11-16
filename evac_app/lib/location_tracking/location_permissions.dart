import 'package:permission_handler/permission_handler.dart';

Future<String> canUseLocation() async {
  // using Permission.location, but may need .locationAlways, etc. instead?

  // check if location permission already granted, if not then request
  if (await Permission.location.request().isGranted) {
    // if permission granted, check if service is enabled (able to be used)
    if (await Permission.location.serviceStatus.isEnabled) {
      // indicate that we can use location
      return 'yes';
    } else {
      // indicate that we cannot use location because the service is disabled
      return 'service disabled';
    }
  } else {
    // indicate that we cannot use location because permission was not granted
    return 'not granted';
  }
}
