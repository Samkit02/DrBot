// To parse this JSON data, do
//
//     final resultModel = resultModelFromJson(jsonString);

import 'dart:convert';

List<ResultModel> resultModelFromJson(String str) => List<ResultModel>.from(json.decode(str).map((x) => ResultModel.fromJson(x)));

String resultModelToJson(List<ResultModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ResultModel {
  ResultModel({
    this.pic,
    this.disease,
    this.ids,
  });

  String? pic;
  String? disease;
  String? ids;

  factory ResultModel.fromJson(Map<String, dynamic> json) => ResultModel(
    pic: json["pic"],
    disease: json["disease"],
    ids: json["ids"],
  );

  Map<String, dynamic> toJson() => {
    "pic": pic,
    "disease": disease,
    "ids": ids,
  };
}
