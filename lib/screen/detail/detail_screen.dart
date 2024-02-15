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
      Provider.of<DetailSurveyProvider>(context, listen: false).getDetailSurveyTest(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Countdown(
              seconds: 60,
              build: (BuildContext context, double time) => Text(
                '${time.round()} second left',
                style: const TextStyle(
                  color: resultColor,
                ),
              ),
              interval: const Duration(seconds: 1),
              onFinished: () {
                print('Timer is done!');
              },
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
            return Column(
              children: [
                QuestionCard(question: state.result.data.question[currentIndex]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: currentIndex > 0 ? () {
                        setState(() {
                          currentIndex--;
                        });
                      } : null,
                      child: Text('Previous'),
                    ),
                    ElevatedButton(
                      onPressed: currentIndex < state.result.data.question.length - 1 ? () {
                        setState(() {
                          currentIndex++;
                        });
                      } : null,
                      child: Text('Next'),
                    ),
                  ],
                ),
              ],
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
      children: [
        Text(question.number),
        Text(question.questionName),
        if (question.type == 'multiple_choice') ...question.options.map((option) => RadioListTile<String>(
          title: Text(option.optionName),
          value: option.optionid,
          groupValue: '',
          onChanged: (value) {},
        )).toList(),
        if (question.type == 'checkbox') ...question.options.map((option) => CheckboxListTile(
          title: Text(option.optionName),
          value: false,
          onChanged: (value) {},
        )).toList(),
        if (question.type == 'text') TextField(),
      ],
    );
  }
}