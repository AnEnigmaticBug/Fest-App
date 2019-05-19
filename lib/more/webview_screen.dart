import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:fest_app/shared/bottom_navigation.dart';
import 'package:fest_app/shared/screen_title.dart';

class WebViewScreen extends StatelessWidget {
  final String title;
  final String url;

  WebViewScreen({
    Key key,
    @required this.title,
    @required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 4.0),
                BackButton(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ScreenTitle(
                    title: title,
                  ),
                ),
              ],
            ),
            Expanded(
              child: WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        initialIndex: 4,
        selectedItemColor: Colors.green,
      ),
    );
  }
}
