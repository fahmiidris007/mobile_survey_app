import 'package:flutter/material.dart';
import 'package:mobile_survey_app/model/detail_survey.dart';
import 'package:mobile_survey_app/model/post_survey.dart';
import 'package:mobile_survey_app/model/survey.dart';
import 'package:mobile_survey_app/provider/detail_survey_provider.dart';
import 'package:mobile_survey_app/provider/post_survey_provider.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DetailSurveyScreen extends StatefulWidget {
  final String id;
  final Participant nikParticipant;

  const DetailSurveyScreen(this.id, this.nikParticipant, {super.key});

  @override
  State<DetailSurveyScreen> createState() => _DetailSurveyScreenState();
}

class _DetailSurveyScreenState extends State<DetailSurveyScreen> {
  int currentIndex = 0;
  PostSurvey postSurvey = PostSurvey(
    assessmentId: '',
    nikParticipant: '',
    answers: [],
  );

  @override
  void initState() {
    super.initState();
    postSurvey = PostSurvey(
      assessmentId: widget.id,
      nikParticipant: widget.nikParticipant.nik,
      answers: [],
    );
    Future.microtask(() {
      Provider.of<DetailSurveyProvider>(context, listen: false)
          .getDetailSurveyTest(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
              decoration: BoxDecoration(
                border: Border.all(color: secondaryColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Countdown(
                seconds: 60,
                build: (BuildContext context, double time) => Text(
                  '${time.round()} second left',
                  style: myTextTheme.bodyLarge?.copyWith(
                    color: secondaryColor,
                  ),
                ),
                interval: const Duration(seconds: 1),
                onFinished: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Time is up!'),
                        content:
                            const Text('Do you want to submit your answer?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.grid_view),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  var questionCount = Provider.of<DetailSurveyProvider>(context).result.data.question.length;
                  return Dialog(
                    alignment: Alignment.topCenter,
                    insetPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.75,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Survey Question',
                                  style: myTextTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: questionCount,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = index;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: secondaryColor,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text('${index + 1}',),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<DetailSurveyProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.noData) {
            return const Center(child: Text('No Data'));
          } else if (state.state == ResultState.error) {
            return Center(child: Text(state.message));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Text(state.result.data.name,
                              style: myTextTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                        QuestionCard(
                          question: state.result.data.question[currentIndex],
                          updateAnswer: updateAnswer,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: currentIndex > 0
                            ? () {
                                setState(() {
                                  currentIndex--;
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(120),
                          backgroundColor: primaryColor,
                          foregroundColor: secondaryColor,
                          textStyle: myTextTheme.titleSmall,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(color: secondaryColor),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                        child: Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: currentIndex <
                                state.result.data.question.length - 1
                            ? () {
                                setState(() {
                                  currentIndex++;
                                });
                              }
                            : () async {
                                final postSurveyProvider =
                                    Provider.of<PostSurveyProvider>(context,
                                        listen: false);
                                await postSurveyProvider.postSurvey(
                                    postSurvey.assessmentId,
                                    postSurvey.nikParticipant,
                                    postSurvey.answers);
                                final state = postSurveyProvider.state;
                                print('The state is $state');
                                if (state == PostResultState.loading) {
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (state == PostResultState.noData) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Please answer all questions'),
                                    ),
                                  );
                                } else if (state == PostResultState.error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Error \n${postSurveyProvider.message}'),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Survey Submitted'),
                                        content:
                                            Text(postSurveyProvider.message),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                setState(() {});
                              },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(120),
                          backgroundColor: secondaryColor,
                          foregroundColor: primaryColor,
                          textStyle: myTextTheme.titleSmall,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                          ),
                        ),
                        child:
                            currentIndex < state.result.data.question.length - 1
                                ? Text('Next')
                                : Text('Finish'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void updateAnswer(String questionId, String selectedOption) {
    // Define a default Answer
    Answer defaultAnswer = Answer(questionId: '', answer: '');

    // Find the answer in the list
    var answer = postSurvey.answers.firstWhere(
        (a) => a.questionId == questionId,
        orElse: () => defaultAnswer);

    if (answer.questionId.isNotEmpty) {
      // If the answer exists, update its value
      answer.answer = selectedOption;
    } else {
      // If the answer doesn't exist, create a new one and add it to the list
      postSurvey.answers
          .add(Answer(questionId: questionId, answer: selectedOption));
    }
  }
}

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function(String, String) updateAnswer;

  const QuestionCard(
      {super.key, required this.question, required this.updateAnswer});

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${widget.question.number}. ${widget.question.questionName}',
            style: myTextTheme.bodyLarge?.copyWith(color: hintColor),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: dividerColor,
          ),
        ),
        if (widget.question.type == 'multiple_choice')
          ...widget.question.options
              .map((option) => RadioListTile<String>(
                    title: Text(option.optionName),
                    value: option.optionid,
                    groupValue: selectedOption,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedOption = value;
                        });
                        widget.updateAnswer(widget.question.questionId, value);
                      }
                    },
                  ))
              .toList(),
        if (widget.question.type == 'checkbox')
          ...widget.question.options
              .map((option) => CheckboxListTile(
                    title: Text(option.optionName),
                    value: selectedOption == option.optionid,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedOption = option.optionid;
                        });
                        widget.updateAnswer(
                            widget.question.questionId, option.optionid);
                      }
                    },
                  ))
              .toList(),
        if (widget.question.type == 'text') TextField(),
      ],
    );
  }
}
