import 'package:flutter/material.dart';

import 'package:fest_app/more/webview_screen.dart';

class SponsorsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebViewScreen(
      title: 'Sponsors',
      url: 'https://bits-apogee.org/sponsors.html',
    );
  }
}
