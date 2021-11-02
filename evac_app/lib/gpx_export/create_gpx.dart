import 'dart:io';

import 'package:evac_app/db/trajectory_database_manager.dart';
import 'package:evac_app/models/participant_location.dart';

class CreateGpx {
  Future<void> fromList(File file) async {
    final databaseManager = TrajectoryDatabaseManager.getInstance();
    List<ParticipantLocation> dataSet = await databaseManager.getTrajectory();

    // TODO: gpx format output
    var sink = file.openWrite();
    sink.write(header);
    sink.write(DateTime.now().toIso8601String());
    sink.write(bodyPreamble);
    for (var entry in dataSet) {
      sink.write(stringifyEntry(entry));
    }
    sink.write(bodyPreamble);
    sink.close();
  }

  String stringifyEntry(ParticipantLocation entry) {
    return entry0 +
        entry.latitude.toString() +
        entry1 +
        entry.longitude.toString() +
        entry2 +
        // ((entry.elevation != null) ? entry.elevation.toString() : '0.0') +
        entry.elevation.toString() +
        entry3 +
        entry.time.toIso8601String() +
        entry4;
  }

  String header =
      '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>\n\n<gpx creator="Oregon State University - Evacuation Research App">\n  <metadata>\n    <link href="https://cce.oregonstate.edu/wang">\n      <text>Dr. Haizhong Wang</text>\n    </link>\n    <time>';
  String bodyPreamble =
      '</time>\n  </metadata>\n  <trk>\n    <name>Participant Trajectory</name>\n    <trkseg>\n      ';
  String entry0 = '      <trkpt lat="';
  String entry1 = '" lon="';
  String entry2 = '"><ele>';
  String entry3 = '</ele><time>';
  String entry4 = '</time></trkpt>\n';
  String footer = '    </trkseg>\n  </trk>\n</gpx>';
}
