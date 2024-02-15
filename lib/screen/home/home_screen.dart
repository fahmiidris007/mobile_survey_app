import 'package:flutter/material.dart';
import 'package:mobile_survey_app/provider/survey_provider.dart';
import 'package:provider/provider.dart';

import 'components/list_card_survey.dart';

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
          padding: EdgeInsets.only(left: 8.0),
          child: Text('Halaman Survei'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            onPressed: () {
              Provider.of<SurveyProvider>(context, listen: false).logout();
              Provider.of<SurveyProvider>(context, listen: false).removeUser();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<SurveyProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.noData) {
              return Center(child: Text(state.message));
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
