// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_survey_app/model/post_survey.dart';
import 'package:mobile_survey_app/model/survey.dart';
import 'package:mobile_survey_app/provider/detail_survey_provider.dart';
import 'package:mobile_survey_app/provider/post_survey_provider.dart';
import 'package:mobile_survey_app/screen/home/home_screen.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

import 'components/question_card.dart';

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
      appBar: customAppBar(context),
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
                      previousButton(),
                      nextButton(state, context),
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

  ElevatedButton nextButton(DetailSurveyProvider state, BuildContext context) {
    return ElevatedButton(
      onPressed: currentIndex < state.result.data.question.length - 1
          ? () {
              setState(() {
                currentIndex++;
              });
            }
          : () async {
              final postSurveyProvider =
                  Provider.of<PostSurveyProvider>(context, listen: false);
              await postSurveyProvider.postSurvey(postSurvey.assessmentId,
                  postSurvey.nikParticipant, postSurvey.answers);
              final state = postSurveyProvider.state;
              if (state == PostResultState.loading) {
                const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state == PostResultState.noData) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(postSurveyProvider.message),
                  ),
                );
              } else if (state == PostResultState.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(postSurveyProvider.message),
                  ),
                );
              } else {
                dialogPostSurvey(context, postSurveyProvider);
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
      child: currentIndex < state.result.data.question.length - 1
          ? const Text('Next')
          : const Text('Finish'),
    );
  }

  Future<dynamic> dialogPostSurvey(
      BuildContext context, PostSurveyProvider postSurveyProvider) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Survey Submitted'),
          content: Text(postSurveyProvider.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  ElevatedButton previousButton() {
    return ElevatedButton(
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
      child: const Text('Previous'),
    );
  }

  AppBar customAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
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
                      content: const Text('Do you want to submit your answer?'),
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
          icon: const Icon(Icons.grid_view),
          onPressed: () {
            popUpGridViewSurvey(context);
          },
        ),
      ],
    );
  }

  Future<dynamic> popUpGridViewSurvey(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        var questionCount = Provider.of<DetailSurveyProvider>(context)
            .result
            .data
            .question
            .length;
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
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  gridViewSurvey(questionCount),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Expanded gridViewSurvey(int questionCount) {
    return Expanded(
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
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: secondaryColor),
              ),
            ),
          );
        },
      ),
    );
  }

  void updateAnswer(String questionId, String selectedOption) {
    Answer defaultAnswer = Answer(questionId: '', answer: '');

    var answer = postSurvey.answers.firstWhere(
        (a) => a.questionId == questionId,
        orElse: () => defaultAnswer);

    if (answer.questionId.isNotEmpty) {
      answer.answer = selectedOption;
    } else {
      postSurvey.answers
          .add(Answer(questionId: questionId, answer: selectedOption));
    }
  }
}
