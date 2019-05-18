import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fest_app/events/event_repository.dart';

class EventsScreen extends StatelessWidget {
  final EventRepository repository;

  EventsScreen({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<EventRepository>(
      builder: (_) => repository,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              'Events Screen',
              style: TextStyle(fontSize: 36.0),
            ),
          ),
        ),
      ),
    );
  }
}
