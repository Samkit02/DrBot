import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drbot/pages/results_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class APIService {

  static var client = http.Client();
  Future<List<ResultModel>?> getDiseaseList() async {
    List<ResultModel>? model = <ResultModel>[];
    String url = 'url/Hemoglobin1/selectUtil.php';
    print(url);
    try {
      var response = await client.get(Uri.parse(url));

      print('status ${response.statusCode}');
      if (response.statusCode == 200) {
        model = resultModelFromJson(response.body);// (response.body as List).map((i) => ResultModel.fromJson(i)).toList();
        print('length: ${model[0].pic}');
        print('length: ${model.length}');
        print('length: ${model}');
      }
    } on DioError catch (e) {
      print('error: ${e.message}');
    }
    return model;
  }
}
