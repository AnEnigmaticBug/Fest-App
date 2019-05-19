import 'package:flutter/material.dart';

import 'package:fest_app/shared/bottom_navigation.dart';
import 'package:fest_app/shared/screen_title.dart';

class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: ScreenTitle(title: 'More'),
              ),
              Expanded(child: _OptionsList()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        initialIndex: 4,
        selectedItemColor: Colors.green,
      ),
    );
  }
}

class _OptionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _MoreOption(
          title: 'About',
          backgrounColor: Colors.purple,
          onPressed: () {
            Navigator.of(context).pushNamed('/about');
          },
        ),
        _MoreOption(
          title: 'Contacts',
          backgrounColor: Colors.indigoAccent,
          onPressed: () {},
        ),
        _MoreOption(
          title: 'Sponsors',
          backgrounColor: Colors.deepOrangeAccent,
          onPressed: () {},
        ),
        _MoreOption(
          title: 'EPC Blog',
          backgrounColor: Colors.blueGrey,
          onPressed: () {},
        ),
        _MoreOption(
          title: 'Developers',
          backgrounColor: Colors.pinkAccent,
          onPressed: () {},
        ),
      ],
    );
  }
}

typedef onPressedCallback = void Function();

class _MoreOption extends StatelessWidget {
  final String title;
  final Color backgrounColor;
  final onPressedCallback onPressed;

  _MoreOption({
    Key key,
    @required this.title,
    @required this.backgrounColor,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Material(
        color: backgrounColor,
        elevation: 12.0,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 24.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          onTap: onPressed,
        ),
      ),
    );
  }
}
