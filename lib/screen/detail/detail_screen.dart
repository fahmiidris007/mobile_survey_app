import 'package:flutter/material.dart';
import 'package:mobile_survey_app/provider/detail_survey_provider.dart';
import 'package:provider/provider.dart';

class DetailSurveyScreen extends StatefulWidget {
  final String id;

  const DetailSurveyScreen({super.key, required this.id});

  @override
  State<DetailSurveyScreen> createState() => _DetailSurveyScreenState();
}

class _DetailSurveyScreenState extends State<DetailSurveyScreen> {
  final Map<String, dynamic> answers = {};

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
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Detail Survey'),
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
            return ListView.builder(
              itemCount: state.result.data.question.length,
              itemBuilder: (context, index) {
                final question = state.result.data.question[index];
                return ListTile(
                  title: Text(question.questionName),
                  // handle the question type here
                  // for example, if the question type is text, show TextField
                  // if the question type is multiple choice/radio_button, show RadioListTile
                  // and so on
                  // also, don't forget to save the answer to the `answers` map
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print({
            "survey_id": widget.id,
            "answers": answers.entries.map((e) => {
              "question_id": e.key,
              "answer": e.value,
            }).toList(),
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
