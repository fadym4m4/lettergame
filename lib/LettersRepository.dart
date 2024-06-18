import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:lettersgame/models/LettersModel.dart';

import 'Constans.dart';
class LettersRepository{
  static const String baseUrl = 'https://mocki.io/v1/f6557703-eaf9-4264-9dbd-99e932166148';
  Future<LettersModel> fetchLetters() async {
    var res= await http.get(Uri.parse('${baseUrl}'));
    var decodeResponse=jsonDecode(res.body);
    return LettersModel.fromJson(decodeResponse);
  }
}