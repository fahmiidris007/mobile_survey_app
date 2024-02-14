import 'package:flutter/material.dart';
import 'package:mobile_survey_app/model/survey.dart';
import 'package:mobile_survey_app/provider/survey_provider.dart';
import 'package:mobile_survey_app/screen/detail/detail_screen.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:mobile_survey_app/utils/date_formater.dart';
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailSurveyScreen(id: survey.id),
          ),
        );      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: labelColor,
            width: 0.5,
          ),
        ),
        child: Card(
          elevation: 0,
          child: ListTile(
            // contentPadding: EdgeInsets.all(8.0),
            leading: Image(image: AssetImage('assets/images/grade.png')),
            title: Text(
              survey.name,
              style: myTextTheme.titleSmall,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Created At: ${DateFormatter.format(survey.createdAt)}',
                  style: const TextStyle(color: resultColor),
                ),
                Text(
                  survey.downloadedAt != null
                      ? 'Last Download: ${DateFormatter.format(survey.downloadedAt)}'
                      : 'Not downloaded yet',
                  style: const TextStyle(color: resultColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
