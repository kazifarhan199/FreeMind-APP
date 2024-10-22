// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:hive/hive.dart';
import 'package:social/models/users.dart';
import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/survey.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/SurveyCard.dart';
import 'package:social/vars.dart';

class Survey extends StatefulWidget {
  bool popup;
  Survey({this.popup=false ,Key? key}) : super(key: key);

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  List<SurveyModel> questions = [];
  bool loading = false;
  int no_questions = 0, no_cuppled = 0;

  Future<void> getSurvey() async {
    if (mounted) setState(() => loading = true);
    try {
      List<SurveyModel> localQuestions = await SurveyModel.getSurvey();
      for (var q in localQuestions) {
        if (q.is_label == false) {
          if (q.is_coupuled == false) {
            no_cuppled++;
          }
          no_questions++;
        }
      }
      if (mounted) setState(() => questions = localQuestions);
    } on Exception catch (e) {
      if (mounted)
        errorBox(
            context: context,
            error: e.toString().substring(11),
            errorTitle: 'Login');
    }
    if (mounted) setState(() => loading = false);
  }

  Future<void> sendQuestionReplyMethod() async {
    if (mounted) setState(() => loading = true);
    for (var question in questions) {
      if (question.rating == 0) {
        errorBox(
            context: context,
            errorTitle: "Error",
            error: ErrorStrings.all_fiields_needed);
        if (mounted) setState(() => loading = false);
        return;
      }
    }
    if (mounted) setState(() => loading = true);

    for (var question in questions) {
      try {
        question.sendQuestionReply();
      } on Exception catch (e) {
        if (mounted)
          errorBox(
              context: context,
              error: e.toString().substring(11),
              errorTitle: 'Error');
      }
    }

    User user = Hive.box('userBox').getAt(0) as User;
    user.surveyGiven = true;
    await Hive.box("userBox").put(0, user);

    print(user.surveyGiven);

    Routing.wrapperPage(context);

    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    getSurvey();
  }

  @override
  Widget build(BuildContext context) {
    return Loading(
      loading: loading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: widget.popup ? Text("Daily Update"):Text("Survey"),
          actions: [
            IconButton(
                onPressed: sendQuestionReplyMethod, icon: Icon(Icons.send)),
          ],
        ),
        body: ListView.builder( 
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: questions.length + 4,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: widget.popup?
                    Text(
                      InfoStrings.surveypopup_info,
                      style: Theme.of(context).textTheme.headline5,
                  ):Text(
                      InfoStrings.survey_info,
                      style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              );
            }

            if (index - 1 < no_cuppled) // index = 5 -> 0-4
              return SurveyCard(
                question: questions[index - 1],
              );

            if (index - 1 == no_cuppled) // index = 6
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 8.0),
                  child: Text(
                    InfoStrings.survey_cuppled_info,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              );

            if (index - 2 < no_questions) // index = 7 -> 5-14
              return SurveyCard(
                question: questions[index - 2],
              );
            if (index - 2 == no_questions) // index = 16
              return InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 8.0),
                  child: Text(
                    InfoStrings.survey_label_info,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              );
            if (index - 3 == no_questions) // index = 17
              return Divider();
            return SurveyCard(
              // index = 18 ->
              question: questions[index - 4],
            );
          },
        ),
      ),
    );
  }
}
