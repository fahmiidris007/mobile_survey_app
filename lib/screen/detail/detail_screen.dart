import 'package:flutter/material.dart';
import 'package:mobile_survey_app/model/detail_survey.dart';
import 'package:mobile_survey_app/provider/detail_survey_provider.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DetailSurveyScreen extends StatefulWidget {
  final String id;

  const DetailSurveyScreen({super.key, required this.id});

  @override
  State<DetailSurveyScreen> createState() => _DetailSurveyScreenState();
}

class _DetailSurveyScreenState extends State<DetailSurveyScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
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
                borderRadius: BorderRadius.circular(5.0),
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
            return SingleChildScrollView(
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
                      question: state.result.data.question[currentIndex]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentIndex > 0
                            ? () {
                                setState(() {
                                  currentIndex--;
                                });
                              }
                            : null,
                        child: Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed:
                            currentIndex < state.result.data.question.length - 1
                                ? () {
                                    setState(() {
                                      currentIndex++;
                                    });
                                  }
                                : null,
                        child:
                            currentIndex < state.result.data.question.length - 1
                                ? Text('Next')
                                : Text('Finish'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  final Question question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${question.number}. ${question.questionName}',
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
        if (question.type == 'multiple_choice')
          ...question.options
              .map((option) => RadioListTile<String>(
                    title: Text(option.optionName),
                    value: option.optionid,
                    groupValue: '',
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onChanged: (value) {},
                  ))
              .toList(),
        if (question.type == 'checkbox')
          ...question.options
              .map((option) => CheckboxListTile(
                    title: Text(option.optionName),
                    value: false,
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onChanged: (value) {},
                  ))
              .toList(),
        if (question.type == 'text') TextField(),
      ],
    );
  }
}
