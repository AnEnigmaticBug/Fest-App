import 'package:flutter/material.dart';

import 'package:fest_app/more/models.dart';
import 'package:fest_app/shared/bottom_navigation.dart';
import 'package:fest_app/shared/screen_title.dart';

const _developers = <Developer>[
  Developer(
    name: 'Nishant Mahajan',
    role: 'App Developer',
    picAsset: 'images/developer1.png',
    gitHubUsername: 'AnEnigmaticBug',
  ),
  Developer(
    name: 'Nishant Mahajan',
    role: 'UI/UX Developer',
    picAsset: 'images/developer1.png',
    gitHubUsername: 'AnEnigmaticBug',
  ),
  Developer(
    name: 'Nishant Mahajan',
    role: 'App Developer',
    picAsset: 'images/developer1.png',
    gitHubUsername: 'AnEnigmaticBug',
  ),
  Developer(
    name: 'Nishant Mahajan',
    role: 'UI/UX Developer',
    picAsset: 'images/developer1.png',
    gitHubUsername: 'AnEnigmaticBug',
  ),
  Developer(
    name: 'Nishant Mahajan',
    role: 'UI/UX Developer',
    picAsset: 'images/developer1.png',
    gitHubUsername: 'AnEnigmaticBug',
  ),
];

class DevelopersScreen extends StatelessWidget {
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
                    title: 'Developers',
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: _DevelopersList(),
              ),
            ),
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

class _DevelopersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 20.0),
      itemCount: _developers.length,
      itemBuilder: (context, index) {
        final color = Colors.accents[index % 6];
        return _DeveloperTile(
            developer: _developers[index], backgroundColor: color);
      },
      separatorBuilder: (context, index) => SizedBox(height: 16.0),
    );
  }
}

class _DeveloperTile extends StatelessWidget {
  final Developer developer;
  final Color backgroundColor;

  _DeveloperTile({
    Key key,
    @required this.developer,
    @required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: 8.0,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(flex: 1, child: _DeveloperInfo(developer: developer)),
              CircleAvatar(
                radius: 40.0,
                backgroundImage: AssetImage(developer.picAsset),
              ),
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}

class _DeveloperInfo extends StatelessWidget {
  final Developer developer;

  _DeveloperInfo({Key key, @required this.developer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _DeveloperName(name: developer.name),
        _DeveloperRole(role: developer.role),
        SizedBox(height: 16.0),
        _DeveloperGitHub(gitHubUsername: developer.gitHubUsername),
      ],
    );
  }
}

class _DeveloperName extends StatelessWidget {
  final String name;

  _DeveloperName({Key key, @required this.name}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(fontSize: 24.0, color: Colors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DeveloperRole extends StatelessWidget {
  final String role;

  _DeveloperRole({Key key, @required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      role,
      style: TextStyle(color: Colors.white),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _DeveloperGitHub extends StatelessWidget {
  final String gitHubUsername;

  _DeveloperGitHub({Key key, @required this.gitHubUsername}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$gitHubUsername@GitHub',
      style: TextStyle(color: Colors.white),
    );
  }
}
