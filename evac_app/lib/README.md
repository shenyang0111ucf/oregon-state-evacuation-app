# Evacuation Drill Participation App - source library
In this directory you will find the Flutter source code for our mobile participant app.

### Top Level
At the top level are `main.dart` and `app.dart` which do the heavy lifting of initializing the runtime environment. Also found at this level have `styles.dart` and `new_styles.dart` which declare the theming for our app.

### [`components`](components)
stores widgets which are reused throughout the app.

### [`db`](db)
stores the class which encapsulates the SQLite/SQFLite database functionality used to store location data during the performance of drills.

### [export](export) 
stores the various encryption and exporter classes which allow for the secure transfer of participant results to the server-less Firebase backend.

### [`extra_dialog_contents`](extra_dialog_contents)
stores contents of various dialogs which are presented within the app, but which do not belong alongside the Widget by which they are shown.

### [`location_tracking`](location_tracking)
stores the classes which abstract the location tracking and permissions gathering.

### [`models`](models)
stores the classes which define the data structures (models) for the app.

### [`pages`](pages)
stores the Widgets which are the main pages of the app: `InviteCodePage` and `TasksPage`. Legacy pages from v1.0.1 are also stored in this directory as of v2.0.0.

### [`presenters`](presenters)
stores the `PagePresenter` Widget which present the `Pages` (and via `TasksPage` buttons, the `TaskDisplays`) based on the `DrillDetails` object. The Legacy `BasicDrillPresenter` from v1.0.1 is also stored in this directory as of v2.0.0.

### [`task_displays`](task_displays)
stores the Widgets which display `Tasks` (via their typed `TaskDetails` class objects). These displays also access the `TaskResult` `make…setter` functions in order to record participant results in the `DrillResults` object.
