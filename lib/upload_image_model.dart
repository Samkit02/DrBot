// To parse this JSON data, do
//
//     final uploadImage = uploadImageFromJson(jsonString);

import 'dart:convert';

UploadImage1 uploadImageFromJson(String str) => UploadImage1.fromJson(json.decode(str));

String uploadImageToJson(UploadImage1 data) => json.encode(data.toJson());

class UploadImage1 {
  UploadImage1({
    this.result,
    this.message,
  });

  String? result;
  String? message;

  factory UploadImage1.fromJson(Map<String, dynamic> json) => UploadImage1(
    result: json["Result"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "Result": result,
    "Message": message,
  };
}