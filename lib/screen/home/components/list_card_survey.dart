import 'package:flutter/material.dart';
import 'package:mobile_survey_app/model/survey.dart';
import 'package:mobile_survey_app/screen/detail/detail_screen.dart';
import 'package:mobile_survey_app/theme/style.dart';
import 'package:mobile_survey_app/utils/date_formater.dart';

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
            builder: (context) => DetailSurveyScreen(
              survey.id,
              survey.participants[0],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
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
            leading: const Image(image: AssetImage('assets/images/grade.png')),
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
