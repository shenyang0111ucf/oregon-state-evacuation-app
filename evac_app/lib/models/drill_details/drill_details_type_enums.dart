/// If this app is developed further, there may be multiple types of drills. Lets define the types as such:

enum DrillType { TSUNAMI }

/// Drill task types range from "tapping a button" to "moving to a new location irl", and are defined more formally below in the DrillTaskType enum.

enum DrillTaskType {
  SURVEY,
  ALLOW_LOCATION_PERMISSIONS,
  WAIT_FOR_START,
  PERFORM_DRILL,
  TRAVEL,
  UPLOAD,
}

/// We want to give researchers options on how they start their participants performing drills. Let's define the types of starts as such:

enum TypeOfWait {
  // SYNCHRONIZED,
  // SIGNAL,
  SELF,
}
