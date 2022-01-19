// This may be subsumed during our transition to "bloc"

class DrillEvent {
  final String preDrillSurveyJSON;
  final String postDrillSurveyJSON;
  String? preDrillResponses;
  String? postDrillResponses;
  final String publicKey;

  DrillEvent({
    required this.preDrillSurveyJSON,
    required this.postDrillSurveyJSON,
    required this.publicKey,
  });

  DrillEvent.example()
      : preDrillSurveyJSON = '{}',
        postDrillSurveyJSON = '{}',
        publicKey = 'abc';
}
