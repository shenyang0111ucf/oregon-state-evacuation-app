// This may be subsumed during our transition to "bloc"

class DrillEvent {
  final DateTime startTime;
  final String publicKey;
  final Map<String, dynamic> preDrillSurveyJSON;
  final Map<String, dynamic> postDrillSurveyJSON;
  String? preDrillResponses;
  String? postDrillResponses;

  DrillEvent({
    required this.startTime,
    required this.publicKey,
    required this.preDrillSurveyJSON,
    required this.postDrillSurveyJSON,
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
        postDrillSurveyJSON = {},
        publicKey = 'abc';
}
