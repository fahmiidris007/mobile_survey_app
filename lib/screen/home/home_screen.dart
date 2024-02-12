import 'package:flutter/material.dart';
import 'package:mobile_survey_app/model/survey.dart';
import 'package:mobile_survey_app/provider/survey_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SurveyProvider>(context, listen: false).fetchSurvey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Text('Halaman Survei'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              Provider.of<SurveyProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<SurveyProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.noData) {
              return const Center(child: Text('No Data'));
            } else if (state.state == ResultState.error) {
              return Center(child: Text(state.message));
            } else {
              return ListView.builder(
                itemCount: state.result.count,
                itemBuilder: (context, index) {
                  final survey = state.result.data[index];
                  return ListCardSurvey(survey: survey);
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ListCardSurvey extends StatelessWidget {
  final Datum survey;

  const ListCardSurvey({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(survey.name),
        subtitle: Text(survey.description),
        // Add more fields of the survey as needed
      ),
    );
  }
}
