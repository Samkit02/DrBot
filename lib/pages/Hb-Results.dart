import 'package:drbot/pages/apiService.dart';
import 'package:drbot/pages/results_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HbResults extends StatefulWidget {
  const HbResults({Key? key}) : super(key: key);

  @override
  State<HbResults> createState() => _HbResultsState();
}

class _HbResultsState extends State<HbResults> {
  APIService? _apiService;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiService = new APIService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: FutureBuilder(
        future: _apiService?.getDiseaseList(),
        builder: (BuildContext context, AsyncSnapshot<List<ResultModel>?> snapshot) {
          if(snapshot.hasData){
            return getData(snapshot.data);
          }
          else if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget getData(List<ResultModel>? snapshot){
    if(snapshot?.isNotEmpty == true) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 0.0, top: 10.0),
                    child: Text(
                        'Image',
                      style: TextStyle(
                          fontSize: 20
                      ),
                    ),
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                    'Level',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot?.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            'http://10.0.2.2:80/Hemoglobin1/images/${snapshot?[index].pic}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${snapshot?[index].disease}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
        ],
      );
    }
    else {
      return Center(
        child: Text('Data Empty'),
      );
    }
  }
}
