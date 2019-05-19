import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fest_app/events/event_repository.dart';
import 'package:fest_app/events/models.dart';
import 'package:fest_app/events/star_button.dart';
import 'package:fest_app/shared/bottom_navigation.dart';

class EventsScreen extends StatelessWidget {
  final EventRepository repository;

  EventsScreen({Key key, @required this.repository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<EventRepository>(
      builder: (_) => repository,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: _ScreenTitle(),
              ),
              Expanded(child: _PageSwitcher()),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigation(
          selectedItemColor: Colors.red,
          initialIndex: 3,
        ),
      ),
    );
  }
}

class _ScreenTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Events', style: TextStyle(fontSize: 32.0));
  }
}

class _PageSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _Page(index: index),
        );
      },
    );
  }
}

class _Page extends StatelessWidget {
  final int index;

  _Page({Key key, @required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.accents[index % Colors.accents.length],
      elevation: 12.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _DateTitle(dateTime: _dateTime),
          ),
          Divider(color: Colors.white),
          Expanded(
            child: _EventListFutureBuilder(dateTime: _dateTime),
          )
        ],
      ),
    );
  }

  DateTime get _dateTime {
    return DateTime(2019, 3, 28).add(Duration(days: index));
  }
}

class _DateTitle extends StatelessWidget {
  final DateTime dateTime;

  _DateTitle({Key key, @required this.dateTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'March ${dateTime.day}',
      style: TextStyle(
          fontSize: 28.0, fontWeight: FontWeight.w600, color: Colors.white),
    );
  }
}

class _EventListFutureBuilder extends StatelessWidget {
  final DateTime dateTime;

  const _EventListFutureBuilder({Key key, @required this.dateTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<EventRepository>(context).filteredEvents,
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          final events = (snapShot.data as List<Event>)
              .where((event) => event.dateTime.day == dateTime.day)
              .toList();

          return _EventList(events: events);
        }

        if (snapShot.hasError) {
          return Center(child: _errorMessage);
        }

        return Center(
          child: CircularProgressIndicator(backgroundColor: Colors.white),
        );
      },
    );
  }

  Widget get _errorMessage {
    return Text(
      'Oops! Something went\nwrong :(',
      style: TextStyle(fontSize: 32.0, color: Colors.white),
      textAlign: TextAlign.center,
    );
  }
}

class _EventList extends StatelessWidget {
  final List<Event> events;

  _EventList({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(events[index].name),
          trailing: StarButton(
            isStarred: events[index].isStarred,
            onToggled: (wasStarred) {
              Provider.of<EventRepository>(context).setStarredStatus(
                  eventId: events[index].id, starred: !wasStarred);
            },
          ),
        );
      },
    );
  }
}
