// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:social/routing.dart';
import 'package:flutter/material.dart';
import 'package:social/models/survey.dart';
import 'package:social/screans/utils/loading.dart';
import 'package:social/screans/utils/errorBox.dart';
import 'package:social/screans/utils/SurveyCard.dart';
import 'package:social/vars.dart';

class Survey extends StatefulWidget {
  const Survey({Key? key}) : super(key: key);

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  List<SurveyModel> questions = [];
  bool loading = false;

  getSurvey() async {
    if (mounted) setState(() => loading = true);
    try {
      List<SurveyModel> localQuestions = await SurveyModel.getSurvey();
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

  sendQuestionReplyMethod() async {
    // if (mounted) setState(() => loading = true);
    for (var question in questions) {
      if (question.rating == 0) {
        errorBox(
            context: context,
            errorTitle: "Error",
            error: ErrorStrings.all_fiields_needed);
        return;
      }
    }
    if (mounted) setState(() => loading = true);

    for (var question in questions) {

      try {
        await question.sendQuestionReply();
      } on Exception catch (e) {
        if (mounted)
          errorBox(
              context: context,
              error: e.toString().substring(11),
              errorTitle: 'Error');
      }
    }

    Navigator.of(context).pop();
    Navigator.of(context).pop();
    Routing.wrapperPage(context);

    if (mounted) setState(() => loading = false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSurvey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Survey"),
        // flexibleSpace: Image(
        //   image: AssetImage('assets/background.png'),
        //   fit: BoxFit.cover,
        // ),
        // backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: sendQuestionReplyMethod, icon: Icon(Icons.send)),
        ],
      ),
      body: Loading(
        loading: loading,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return SurveyCard(
              question: questions[index],
            );
          },
        ),
      ),
    );
  }
}
