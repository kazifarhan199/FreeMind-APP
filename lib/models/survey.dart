import 'package:social/models/request.dart';

class SurveyModel{
  String text;
  int id, rating = 0;

  SurveyModel({required this.text, required this.id});

  static SurveyModel fromJson(Map data){
    String text = data['text'] ?? 'survey question';
    int id = data['id'] ?? 0;
    return SurveyModel(text: text, id: id);
  }

  Future<bool> sendQuestionReply() async {
    try{
      await requestIfPossible(
        url: '/recommendations/rating/',
        requestMethod: 'POST',
        body: {'label': this.id.toString(), 'rating': this.rating.toString()},
        expectedCode: 201,
      );
     return true;
    }on Exception catch(e){
      print(e);
      return false;
      // throw Exception(text.toString()+' ' + e.toString().substring(11));
    } 
  }

  static Future<List<SurveyModel>> getSurvey() async {
    try{
      List<SurveyModel> questions = await getSurveyQuestions();
      questions += await getSurveyLabels();
      return questions;
    } on Exception catch( e){
      throw e;
    }
  }

  static Future<List<SurveyModel>> getSurveyQuestions() async {
    try{
      Map data = await requestIfPossible(
        url: '/recommendations/',
        requestMethod: 'GET',
        expectedCode: 200,
      );
      List<SurveyModel> questions = data["results"].map((d) => SurveyModel.fromJson(d))
          .toList()
          .cast<SurveyModel>();
        return questions;
    } on Exception catch(e){
      throw e;
    } 
  }

  static Future<List<SurveyModel>> getSurveyLabels() async {
    try{
      Map data = await requestIfPossible(
        url: '/recommendations/labels/',
        requestMethod: 'GET',
        expectedCode: 200,
      );
      List<SurveyModel> labels = data["results"].map((d) => SurveyModel.fromJson(d))
          .toList()
          .cast<SurveyModel>();
      return labels;
    } on Exception catch(e){
      throw e;
    } 
  }
}