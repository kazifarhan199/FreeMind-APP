// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:social/models/survey.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SurveyCard extends StatefulWidget {
  SurveyModel question;
  SurveyCard({required this.question, Key? key}) : super(key: key);

  @override
  State<SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onDoubleTap: () {},
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.question.text,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      RatingBar.builder(
                        itemSize: 40,
                        initialRating: widget.question.rating.toDouble(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                          }
                          return Icon(
                            Icons.sentiment_very_satisfied,
                            color: Colors.green,
                          );
                        },
                        onRatingUpdate: (val) => widget.question.rating = val.toInt(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
