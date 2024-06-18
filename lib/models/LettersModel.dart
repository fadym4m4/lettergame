class LettersModel {
  List<String>? letters;

  LettersModel({this.letters});

  LettersModel.fromJson(Map<String, dynamic> json) {
    letters = json['letters'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['letters'] = this.letters;
    return data;
  }
}