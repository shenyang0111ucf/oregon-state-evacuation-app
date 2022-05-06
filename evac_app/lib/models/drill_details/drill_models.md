# Drill Models
### *Last Modified:*
**30 April 2022**
## Source Code for Subjects: 
[DrillDetails](./drill_details.dart), [DrillTasks](./drill_tasks/drill_task.dart), [TaskDetails](./drill_tasks/task_details/task_details.dart), [TaskResult](./drill_tasks/task_results/task_result.dart), [Drill Results](../drill_results/drill_results.dart).

## Descriptions:
Drills are defined by their details. Therefore, this DrillDetails model contains all of the necessary information for the app to (1) administer a drill to a participant, (2) generate the associated datasets, and (3) deliver those datasets back to the researchers in the format they so choose.

```dart
class DrillDetails {
    static const DrillType drillType = DrillType.TSUNAMI; // defined below
    final String drillID; // fill in when parsing from Firestore
    final String inviteCode;
    final String title;
    final String meetingLocationPlainText;
    final DateTime? meetingDateTime;
        // ^ forced nullable on .tryParse(), need to handle...
    final String? blurb;
    final String? description;
    final String publicKey;
    final List<DrillTask> tasks;
    // final String? gcp_endpoint_url; // for other teams to receive their results
}
```

If this app is developed further, there may be multiple types of drills. Lets define the types as such:
```dart
enum DrillType {
    TSUNAMI
}
```

Drills are made up of the tasks which participants complete within the duration. This DrillTask model allows DrillDetails to include the details that describe these tasks. 
```dart
class DrillTask {
    final int index; // add during parse on mobile 
    final String taskID;
    final DrillTaskType taskType;
    final TaskDetails details;
}
```
Drill task types range from "tapping a button" to "moving to a new location irl", and are defined more formally below in the DrillTaskType enum. 
```dart
enum DrillTaskType {
    SURVEY,
    ALLOW_LOCATION_PERMISSIONS,
    WAIT_FOR_START,
    PERFORM_DRILL, 
    TRAVEL,
}
```
In order for the app to administer different types of tasks, it must be provided different types of details. These **[_task_]Details** models allow `DrillDetails` to described those different types of details.

DrillTask detail abstract class:
```dart
class TaskDetails {
    Map<String, dynamic> toJson();
}
```

DrillTask detail fields:
```dart
class SurveyDetails {
    final int taskID;
    final String title;
    final Map<String, dynamic> surveyKitJson;
}
```
```dart
class AllowLocationPermissionsDetails {
    final int taskID;
}
```
```dart
class WaitForStartDetails {
    /// if(PerformDrillDetails.trackingLocation)
    ///     `WaitForStart` task should also `AcquireGPS` 
    final int taskID;
    final int performDrillTaskID;
    final TypeOfWait typeOfWait;
    final Map<String, dynamic>? content; 
        // that's right, there's potentially one more level required to do some tasks right. We could instead define three different `DrillTaskType`s for three current types of WaitForStart, but that complicates things too much on the backend (drill creation and whatnot).
        // for now, let's only implement `SELF` and make the other two throw `UnimplementedError`
}
```
```dart
class PerformDrillDetails {
    final int taskID;
    final bool trackingLocation;
    final Map<String, dynamic> instructionsJson;
    // outputFormat String?,
    //              enum OutputFormat{GPX,GEOJSON,RAW}?,
}
```
```dart
class TravelDetails {
    final int taskID;
    final String locationName;
    final double latitude;
    final double longitude;
    final String blurb;
    final DateTime? meetingTime;
    final String? explanation;
    final String? imageURL;
    final String? mapImageURL;
    final String? mapsLink; // can this be generated for google maps by latitude + longitude? yes, but maybe they want to link to a place, like a named building, google maps is the best database for this anyways let them link how they choose. Then if no link make a google maps link why not.
}
```
TypeOfWait enum (for `WaitForStartDetails` above):
```dart
enum TypeOfWait {
    SYNCHRONIZED,
    SIGNAL,
    SELF,
}
```
So now that we've defined all the different tasks and their details, what good does it do us? Not much, unless we have a way to collect the results of participants completing these tasks.

Therefore, each DrillTask will also have a **[_task_]Result** model correlated with it. 

Notes: 
+ We will see further down that each of these **[_task_]Result**s will be collected into the new `DrillResults` model.
+ If updating a result (retaken survey, etc.) need to overwrite entire object, not modify existing.

DrillTask result abstract class:
```dart
class TaskResults {
    Map<String, dynamic> toJson();
}
```

DrillTask result types:
```dart
class SurveyTaskResult { // needs "Task" in name, SurveyKit already has `SurveyResult`
    static const DrillTaskType taskType = DrillTaskType.SURVEY;
    final int taskID;
    final String title;
    final Map<String, dynamic> surveyKitJson;
    final Map<String, dynamic> surveyAnswersJson;
}
```

```dart
class AllowLocationPermissionsResult {
    static const DrillTaskType taskType = DrillTaskType.ALLOW_LOCATION_PERMISSIONS;
    final int taskID;
    final bool allowed;
}
```

```dart
class WaitForStartResult {
    static const DrillTaskType taskType = DrillTaskType.WAIT_FOR_START;
    final int taskID;
    final int performDrillTaskID;
    final TypeOfWait typeOfWait;
}
```

```dart
class PerformDrillResult {
    static const DrillTaskType taskType = DrillTaskType.PERFORM_DRILL;
    final int taskID;
    final bool trackingLocation;
    final Map<String, dynamic> instructionsJson;
    DateTime startTime;
    DateTime endTime;
    Duration? duration;
    double? distanceTravelled; // in (m)
    String? trajectoryFile;
}
```

```dart
class TravelResult {
    static const DrillTaskType taskType = DrillTaskType.TRAVEL;
    final int taskID;
}
```

To hold all of these **[_task_]Result**s, along with meta-info (userID, drillID), we will redefine the `DrillResults` model as follows

```dart
class DrillResults {
    final String drillID;
    final String userID;
    final List<TaskResult> taskResults;
}
```

## Example:

example DrillDetails

```dart
DrillDetails.example()
      : drillID = '123abc',
        inviteCode = '876543',
        title = 'Example Tsunami Evacuation Drill',
        meetingLocationPlainText = 'Oceanside, OR',
        meetingDateTime =
            DateTime.tryParse('2022-05-2 11:00') ?? null, 
                // forced nullable on .tryParse(), need to handle...
        blurb =
            'Help us evaluate the current evacuation infrastructure of Oceanside!',
        description = null,
        publicKey = 'abc123',
        tasks = [
          DrillTask(
            index: 0,
            taskID: 'abc123-0',
            taskType: DrillTaskType.TRAVEL,
            details: TravelDetails.example(
              'Oceanside Post Office',
              'Meet Researchers',
            ),
          ),
          DrillTask(
            index: 1,
            taskID: 'abc123-1',
            taskType: DrillTaskType.ALLOW_LOCATION_PERMISSIONS,
            details: AllowLocationPermissionsDetails.example(),
          ),
          DrillTask(
            index: 2,
            taskID: 'abc123-2',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePre('Pre-Drill'),
          ),
          DrillTask(
            index: 3,
            taskID: 'abc123-3',
            taskType: DrillTaskType.TRAVEL,
            details: TravelDetails.example(
              'Oceanside Beach State Park',
              'Go to Drill-Start Location',
            ),
          ),
          DrillTask(
            index: 4,
            taskID: 'abc123-4',
            taskType: DrillTaskType.WAIT_FOR_START,
            details: WaitForStartDetails.example(),
          ),
          DrillTask(
            index: 5,
            taskID: 'abc123-5',
            taskType: DrillTaskType.PERFORM_DRILL,
            details: PerformDrillDetails.example(),
          ),
          DrillTask(
            index: 6,
            taskID: 'abc123-6',
            taskType: DrillTaskType.SURVEY,
            details: SurveyDetails.examplePost('Post-Drill'),
          ),
          DrillTask(
            index: 7,
            taskID: 'abc123-7',
            taskType: DrillTaskType.TRAVEL,
            details: TravelDetails.example(
              'Oceanside Post Office',
              'Regroup with Researchers',
            ),
          ),
        ];
```
