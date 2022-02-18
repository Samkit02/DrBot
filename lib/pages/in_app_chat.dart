import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppChat extends StatefulWidget {
  const InAppChat({ Key? key }) : super(key: key);

  @override
  _InAppChatState createState() => _InAppChatState();
}

class _InAppChatState extends State<InAppChat> {

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
              url: Uri.parse("https://web.leena.ai/?clientId=PAOW5rS5b8O0kJxIBBKBV")
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