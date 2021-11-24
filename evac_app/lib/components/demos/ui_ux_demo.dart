import 'package:evac_app/components/demos/location_demo.dart';
import 'package:evac_app/components/evac_app_scaffold.dart';
import 'package:evac_app/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/survey_kit.dart';

// borrowing heavily from https://github.com/quickbirdstudios/survey_kit/blob/main/example/lib/main.dart [accessed Nov 15 2021]

class UiUxDemo extends StatefulWidget {
  const UiUxDemo({Key? key}) : super(key: key);

  @override
  _UiUxDemoState createState() => _UiUxDemoState();
}

class _UiUxDemoState extends State<UiUxDemo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.backgroundColor,
      child: Align(
        alignment: Alignment.center,
        child: FutureBuilder<Task>(
          future: getSampleTask(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data != null) {
              final task = snapshot.data!;
              return DefaultTextStyle(
                style: Styles.normalText,
                child: SurveyKit(
                  onResult: (SurveyResult result) {
                    print(result.finishReason);
                    for (var stepResult in result.results) {
                      for (var questionResult in stepResult.results) {
                        // Here are your question results
                        print(questionResult.result);
                      }
                    }
                  },
                  task: task,
                  themeData: Styles.darkTheme.copyWith(
                    cupertinoOverrideTheme: CupertinoThemeData(
                      brightness: Brightness.dark,
                      barBackgroundColor: Styles.backgroundColor,
                      textTheme: CupertinoTextThemeData(
                        textStyle: Styles.normalText.copyWith(fontSize: 24),
                      ),
                    ),
                    outlinedButtonTheme: Styles.outlinedButtonTheme,
                    textButtonTheme: Styles.textButtonTheme,
                  ),
                ),
              );
            }
            return CircularProgressIndicator.adaptive();
          },
        ),
      ),
    );
  }

  Future<Task> getSampleTask() {
    var task = NavigableTask(
      id: TaskIdentifier(),
      steps: [
        InstructionStep(
          title: 'Welcome to\nEvacuation App',
          text: 'Pre-Drill Survey',
          buttonText: 'I\'m Ready!',
        ),
        QuestionStep(
          title: 'Are you a new participant?',
          answerFormat: BooleanAnswerFormat(
            positiveAnswer: 'Yes',
            negativeAnswer: 'No',
            result: BooleanResult.POSITIVE,
          ),
        ),
        QuestionStep(
          title: 'How many drills have you previously completed?',
          answerFormat: IntegerAnswerFormat(
            defaultValue: 2,
          ),
          isOptional: true,
        ),
        QuestionStep(
          title: 'How old are you?',
          answerFormat: IntegerAnswerFormat(
            defaultValue: 25,
            hint: 'Please enter your age',
          ),
          isOptional: true,
        ),
        QuestionStep(
          title: 'Anything else you would like to share?',
          text: 'Tell us what made you interested in this research... etc',
          answerFormat: TextAnswerFormat(
            maxLines: 5,
            validationRegEx: "^(?!\s*\$).+",
          ),
        ),
        QuestionStep(
          title: 'Select your current level of preparedness',
          text: '1 - Very unprepared \n5 - Very prepared',
          answerFormat: ScaleAnswerFormat(
            step: 1,
            minimumValue: 1,
            maximumValue: 5,
            defaultValue: 3,
            minimumValueDescription: '1',
            maximumValueDescription: '5',
          ),
        ),

        // Maybe we can find a use for this format but I haven't thought of one
        // for the survey just yet.
        /*
        QuestionStep(
          title: 'Known allergies',
          text: 'Do you have any allergies that we should be aware of?',
          answerFormat: MultipleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'Penicillin', value: 'Penicillin'),
              TextChoice(text: 'Latex', value: 'Latex'),
              TextChoice(text: 'Pet', value: 'Pet'),
              TextChoice(text: 'Pollen', value: 'Pollen'),
            ],
          ),
        ),
        */

        QuestionStep(
          title: 'Do you need to review your answers?',
          //text: 'Are you ready to begin your drill?',
          answerFormat: SingleChoiceAnswerFormat(
            textChoices: [
              TextChoice(text: 'No', value: 'No'),
              TextChoice(text: 'Yes', value: 'Yes'),
            ],
            defaultSelection: TextChoice(text: 'Yes', value: 'Yes'),
          ),
        ),

        /*
        QuestionStep(
          title: 'When did you wake up?',
          answerFormat: TimeAnswerFormat(
            defaultValue: TimeOfDay(
              hour: 12,
              minute: 0,
            ),
          ),
        ),
        QuestionStep(
          title: 'When was your last holiday?',
          answerFormat: DateAnswerFormat(
            minDate: DateTime.utc(1970),
            defaultDate: DateTime.now(),
            maxDate: DateTime.now(),
          ),
        ),
        
      */

        CompletionStep(
          stepIdentifier: StepIdentifier(id: '321'),
          text: 'Thanks for taking the survey, your drill will begin soon!',
          title: 'Finished!',
          buttonText: 'Submit survey',
        ),
      ],
    );
    task.addNavigationRule(
      forTriggerStepIdentifier: task.steps[6].stepIdentifier,
      navigationRule: ConditionalNavigationRule(
        resultToStepIdentifierMapper: (input) {
          switch (input) {
            case "Yes":
              return task.steps[0].stepIdentifier;
            case "No":
              return task.steps[7].stepIdentifier;
            default:
              return null;
          }
        },
      ),
    );
    return Future.value(task);
  }
}
