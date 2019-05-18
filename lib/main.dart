import 'package:flutter/material.dart';

import 'package:fest_app/events/event_api.dart';
import 'package:fest_app/events/event_repository_impl.dart';
import 'package:fest_app/events/events_screen.dart';
import 'package:fest_app/shared/database_helper.dart';

void main() async {
  final database = await databaseInstance();
  final repository = EventRepositoryImpl(db: database, eventApi: EventApi());
  runApp(FestApp(repository: repository));
}

class FestApp extends StatelessWidget {
  final EventRepository repository;

  FestApp({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fest App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventsScreen(repository: repository),
    );
  }
}
