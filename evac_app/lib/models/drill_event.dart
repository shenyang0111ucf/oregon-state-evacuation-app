// This may be subsumed during our transition to "bloc"

class DrillEvent {
  final DateTime startTime;
  final String publicKey;
  final Map<String, dynamic> preDrillSurveyJSON;
  final Map<String, dynamic> postDrillSurveyJSON;
  final Map<String, dynamic> duringDrillInstructionsJSON;
  String? preDrillResponses;
  String? postDrillResponses;
  String? meetingLocationPlainText;
  DateTime? meetingDateTime;
  // double meetingLatitude;
  // double meetingLongitude;

  DrillEvent({
    required this.startTime,
    required this.publicKey,
    required this.preDrillSurveyJSON,
    required this.postDrillSurveyJSON,
    required this.duringDrillInstructionsJSON,
  });

  DrillEvent.example()
      : startTime = DateTime.now(),
        preDrillSurveyJSON = {
          'id': "123",
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
            {
              "stepIdentifier": {"id": "10"},
              'type': 'completion',
              'text':
                  'Thanks for taking the survey, your drill will begin soon!',
              'title': 'Finished!',
              'buttonText': 'Submit survey',
            }
          ]
        },
        duringDrillInstructionsJSON = {},
        postDrillSurveyJSON = {
          'id': "456",
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
        },
        publicKey = 'abc',
        meetingLocationPlainText = "Oceanside, Oregon",
        meetingDateTime = DateTime.tryParse('2022-02-18 14:00');
}
