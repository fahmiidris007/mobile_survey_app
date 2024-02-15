import 'package:flutter/material.dart';
import 'package:mobile_survey_app/model/detail_survey.dart';
import 'package:mobile_survey_app/theme/style.dart';

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
  Set<String> selectedOptions = {};

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
          decoration: const BoxDecoration(
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
                    value: selectedOptions.contains(option.optionid),
                    visualDensity: const VisualDensity(
                      horizontal: VisualDensity.minimumDensity,
                      vertical: VisualDensity.minimumDensity,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          if (value) {
                            selectedOptions.add(option.optionid);
                          } else {
                            selectedOptions.remove(option.optionid);
                          }
                        });
                        widget.updateAnswer(widget.question.questionId,
                            selectedOptions.toList().join(','));
                      }
                    },
                  ))
              .toList(),
        if (widget.question.type == 'text') const TextField(),
      ],
    );
  }
}
