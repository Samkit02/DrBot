import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AyurvedicChatbot extends StatefulWidget {
  const AyurvedicChatbot({Key? key}) : super(key: key);

  @override
  _AyurvedicChatbotState createState() => _AyurvedicChatbotState();
}

class _AyurvedicChatbotState extends State<AyurvedicChatbot> {

  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  final List<String> _data = [];

  static const String BOT_URL = 'https://drbot-chatbot.herokuapp.com/';
  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: const Color(0xff181461),
        centerTitle: true,
        title: const Text('Ayurvedic Chatbot'),
      ),
      body: Stack(
        children: <Widget>[
          AnimatedList(
            key: _listKey,
            initialItemCount: _data.length,
            itemBuilder: (BuildContext context, int index, Animation<double> animation) {
              return buildItem(_data[index], animation, index);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ColorFiltered(
              colorFilter: const ColorFilter.linearToSrgbGamma(),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.message,
                        color: Color(0xff181461),
                      ),
                      hintText: 'Hello!!',
                      fillColor: Colors.white12,
                    ),
                    controller: queryController,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (msg) {
                      getResponse();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getResponse() {
    if(queryController.text.length > 0) {
      insertSingleItem(queryController.text);
      var client = getClient();
      try {
        client.post(
          Uri.parse(BOT_URL),
          body: {'query': queryController.text},

        ).then((response) {
          print(response.body);
          Map<String, dynamic> data = jsonDecode(response.body);
          insertSingleItem(data['response'] + '<bot>');
        });
      }

      finally {
        client.close();
        queryController.clear();
      }
    }
  }

  void insertSingleItem(String message) {
    _data.add(message);
    _listKey.currentState?.insertItem(_data.length - 1);
  }

  http.Client getClient() {
    return http.Client();
  }

  Widget buildItem(String item, Animation<double> animation, int index) {
    bool mine = item.endsWith('<bot>');
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          alignment: mine ? Alignment.topLeft : Alignment.topRight,
          child: Bubble(
            child: Text(
              item.replaceAll('<bot>', ''),
              style: TextStyle(
                color: mine ? Colors.white : Colors.black,
              ),
            ),
            color: mine ? const Color(0xff181461) : Colors.grey[200],
            padding: const BubbleEdges.all(10),
          ),
        ),
      ),
    );
  }
}
