import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AllopathicChatbot extends StatefulWidget {
  const AllopathicChatbot({ Key? key }) : super(key: key);

  @override
  _AllopathicChatbotState createState() => _AllopathicChatbotState();
}

class _AllopathicChatbotState extends State<AllopathicChatbot> {

  double _progress = 0;
  late InAppWebViewController webView;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: Uri.parse("url")
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
            },
            onProgressChanged: (InAppWebViewController controller, int progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          _progress < 1
          ? SizedBox(
            height: 3,
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.blue.withOpacity(0.2),
            ),
          )
          : SizedBox()
        ],
      ),
    );
  }
}
