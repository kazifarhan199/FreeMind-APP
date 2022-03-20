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
  int no_questions=0;

  getSurvey() async {
    if (mounted) setState(() => loading = true);
    try {
      List<SurveyModel> localQuestions = await SurveyModel.getSurvey();
      for (var q in localQuestions) {
        if(q.is_label==false)
          no_questions++;
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
          itemCount: questions.length+3,
          itemBuilder: (context, index) {
            if (index == 0){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(InfoStrings.survey_info, style: Theme.of(context).textTheme.headline6,)),
              );
            }
            if(index-1 < no_questions)
              return SurveyCard(
                question: questions[index-1],
              );
            if(index-1 == no_questions)
              return InkWell(
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Text(InfoStrings.survey_label_info, style: Theme.of(context).textTheme.headline5,),
                ),
              );
            if(index-2 == no_questions)
              return Divider();
            return SurveyCard(
              question: questions[index-3],
            );
          },
        ),
      ),
    );
  }
}
