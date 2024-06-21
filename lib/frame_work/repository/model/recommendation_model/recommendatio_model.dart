import 'dart:convert';

class RecommendationModel {
  final String? fullName;
  final String? companyName;
  final String? schoolName;
  final String? url;
  final String? headline;
  final List<String>? skills;
  final String? text;
  final String? status;

  RecommendationModel({
    this.fullName,
    this.companyName,
    this.schoolName,
    this.url,
    this.headline,
    this.skills,
    this.text,
    this.status,
  });

  factory RecommendationModel.fromJson(String str) => RecommendationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RecommendationModel.fromMap(Map<String, dynamic> json) => RecommendationModel(
    fullName: json["Full Name"],
    companyName: json["Company Name"],
    schoolName: json["School Name"],
    url: json["URL"],
    headline: json["Headline"],
    skills: json["Skills"] == null ? [] : List<String>.from(json["Skills"]!.map((x) => x)),
    text: json["Text"],
    status: json["Status"],
  );

  Map<String, dynamic> toMap() => {
    "Full Name": fullName,
    "Company Name": companyName,
    "School Name": schoolName,
    "URL": url,
    "Headline": headline,
    "Skills": skills == null ? [] : List<dynamic>.from(skills!.map((x) => x)),
    "Text": text,
    "Status": status,
  };
}
