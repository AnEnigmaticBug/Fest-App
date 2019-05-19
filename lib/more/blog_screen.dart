import 'package:flutter/material.dart';

import 'package:fest_app/more/webview_screen.dart';

class BlogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebViewScreen(
      title: 'EPC Blog',
      url: 'https://epcbits.wordpress.com/',
    );
  }
}
