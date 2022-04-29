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

  SurveyDetails.example(this.title)
      : taskID = 'abc123',
        surveyKitJson = preDrillSurveyExampleJson;

  SurveyDetails.examplePre(this.title)
      : taskID = 'abc123',
        surveyKitJson = preDrillSurveyExampleJson;

  SurveyDetails.examplePost(this.title)
      : taskID = 'abc123',
        surveyKitJson = postDrillSurveyExampleJson;

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
      'title': 'Is this a survey?',
      'answerFormat': {
        'type': 'bool',
        'positiveAnswer': 'Yes',
        'negativeAnswer': 'No',
        'result': 'POSITIVE',
      },
    },
    // cannot grab location permissions yet from QuestionStep as no ability to pass function. Maybe navigation rule?
    {
      'type': 'question',
      'title': 'Can we track your location?',
      'answerFormat': {
        'type': 'bool',
        'positiveAnswer': 'Yes',
        'negativeAnswer': 'No',
        'result': 'POSITIVE',
      },
    },
    // integer type does not remove keyboard display on entry...
    {
      "type": "question",
      "title": "How old are you?",
      "answerFormat": {"type": "integer", "hint": "Please enter your age"}
    },

    {
      "type": "question",
      "title": "How old are you?",
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
      "title": "Known allergies",
      "answerFormat": {
        "type": "multiple",
        "textChoices": [
          {"text": "Penicillin", "value": "Penicillin"},
          {"text": "Latex", "value": "Latex"},
          {"text": "Pet", "value": "Pet"},
          {"text": "Pollen", "value": "Pollen"}
        ]
      }
    },
    {
      "type": "question",
      "title": "Done?",
      "text": "We are done, do you mind to tell us more about yourself?",
      "answerFormat": {
        "type": "single",
        "textChoices": [
          {"text": "Yes", "value": "Yes"},
          {"text": "No", "value": "No"}
        ]
      }
    },
    {
      "type": "question",
      "title": "Tell us about you",
      "text": "Tell us about yourself and why you want to improve your health.",
      "answerFormat": {
        "type": "text",
        "maxLines": 5,
        "validationRegEx": "^(?!\s*\$).+"
      }
    },

    /// doesn't work without defaultValue, but defaultValue doesn't display that value (instead displays current time, probably from DateTime.now()) however it DOES submit the defaultValue if form is not interacted with
    // {
    //   "type": "question",
    //   "title": "When did you wake up?",
    //   "answerFormat": {
    //     "type": "time",
    //     // "defaultValue": {"hour": 12, "minute": 0}
    //   }
    // },
    {
      "type": "question",
      "title": "When was your last holiday?",
      "answerFormat": {
        "type": "date",
        "minDate": "2015-06-25T04:08:16Z",
        "maxDate": "2025-06-25T04:08:16Z",
        "defaultDate": "2021-06-25T04:08:16Z"
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
      'title': 'Is this a survey?',
      'answerFormat': {
        'type': 'bool',
        'positiveAnswer': 'Yes',
        'negativeAnswer': 'No',
        'result': 'POSITIVE',
      },
    },
    // cannot grab location permissions yet from QuestionStep as no ability to pass function. Maybe navigation rule?
    {
      'type': 'question',
      'title': 'Did we track your location?',
      'answerFormat': {
        'type': 'bool',
        'positiveAnswer': 'Yes',
        'negativeAnswer': 'No',
        'result': 'POSITIVE',
      },
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
