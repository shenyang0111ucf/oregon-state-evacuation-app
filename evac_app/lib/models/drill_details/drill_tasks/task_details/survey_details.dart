import 'package:evac_app/models/drill_details/drill_tasks/task_details/task_details.dart';

class SurveyDetails extends TaskDetails {
  final String taskID;
  final String title;
  final Map<String, dynamic> surveyKitJson;

  SurveyDetails({
    required this.taskID,
    required this.title,
    required this.surveyKitJson,
  });

  SurveyDetails.example(this.title, this.taskID)
      : surveyKitJson = preDrillSurveyExampleJson;

  SurveyDetails.examplePre(this.title, this.taskID)
      : surveyKitJson = preDrillSurveyExampleJson;

  SurveyDetails.examplePost(this.title, this.taskID)
      : surveyKitJson = postDrillSurveyExampleJson;

  factory SurveyDetails.fromJson(Map<String, dynamic> json) => SurveyDetails(
      taskID: json['taskID'],
      title: json['title'],
      surveyKitJson: json['surveyKitJson']);

  Map<String, dynamic> toJson() => {
        'taskID': taskID,
        'title': title,
        'surveyKitJson': surveyKitJson,
      };
}

Map<String, dynamic> preDrillSurveyExampleJson = {
  'id': "preDrillSurvey",
  'type': 'navigable',
  'steps': [
    {
      'type': 'intro',
      'title': 'Welcome to the\nEvacuation Drill',
      'text': 'Up first: Pre-Drill Survey',
      'buttonText': 'I\'m Ready!',
    },
    {
      'type': 'question',
      'title': 'Have you participated in an Evacuation Drill before?',
      'answerFormat': {
        'type': 'bool',
        'positiveAnswer': 'Yes',
        'negativeAnswer': 'No',
        'result': 'POSITIVE',
      },
    },
    {
      "type": "question",
      "title":
          "How familiar are you with the location of this Evacuation Drill?",
      "answerFormat": {
        "type": "scale",
        "step": 1,
        "minimumValue": 1,
        "maximumValue": 5,
        "defaultValue": 3,
        "minimumValueDescription": "1",
        "maximumValueDescription": "5"
      }
    },
    {
      "type": "question",
      "title":
          "How prepared do you feel to perform the Evacuation Drill described by the Drill Coordinator?",
      "answerFormat": {
        "type": "scale",
        "step": 1,
        "minimumValue": 1,
        "maximumValue": 5,
        "defaultValue": 3,
        "minimumValueDescription": "1",
        "maximumValueDescription": "5"
      }
    },
    {
      "stepIdentifier": {"id": "10"},
      'type': 'completion',
      'text': 'Thanks for taking the survey, your drill will begin soon!',
      'title': 'Finished!',
      'buttonText': 'Submit survey',
    }
  ]
};

Map<String, dynamic> postDrillSurveyExampleJson = {
  'id': "postDrillSurvey",
  'type': 'navigable',
  'steps': [
    {
      'type': 'intro',
      'title': 'Thanks for participating in the\nEvacuation Drill',
      'text': 'Up next: Post-Drill Survey',
      'buttonText': 'I\'m Ready!',
    },
    {
      'type': 'question',
      'title': 'Were you able to complete the Evacuation Drill successfully?',
      'answerFormat': {
        'type': 'bool',
        'positiveAnswer': 'Yes',
        'negativeAnswer': 'No',
        'result': 'POSITIVE',
      },
    },
    {
      "type": "question",
      "title":
          "How prepared do you feel to evacuate from the Drill location, now that you've had a practice run?",
      "answerFormat": {
        "type": "scale",
        "step": 1,
        "minimumValue": 1,
        "maximumValue": 5,
        "defaultValue": 3,
        "minimumValueDescription": "1",
        "maximumValueDescription": "5"
      }
    },
    {
      "type": "question",
      "title": "Did anything interesting happen?",
      "text":
          "Is there anything you want your Drill Coordinator to know about your drill participation? Anything that went right or wrong, good or bad?",
      "answerFormat": {
        "type": "text",
        "maxLines": 5,
        "validationRegEx": "^(?!\s*\$).+"
      }
    },
    {
      "stepIdentifier": {"id": "10"},
      'type': 'completion',
      'text':
          'Thanks for taking the survey, and for participating in this drill!',
      'title': 'Finished!',
      'buttonText': 'Submit survey & Export drill results',
    }
  ]
};
