import 'package:flutter/material.dart';

import 'package:fest_app/events/models.dart';
import 'package:fest_app/shared/util.dart';

class EventSheet extends StatelessWidget {
  final Event event;

  EventSheet({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20.0),
          _EventName(event: event),
          SizedBox(height: 8.0),
          Text('${prettyPrintDateTime(event.dateTime)} at $_spotInfo'),
          SizedBox(height: 12.0),
          _ChipList(items: event.types.map((type) => type.name).toList()),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 20.0),
              children: <Widget>[
                if (event.about.isNotEmpty)
                  _HeadedText(heading: 'About', content: event.about),
                if (event.rules.isNotEmpty)
                  _HeadedText(heading: 'Rules', content: event.rules),
              ],
            ),
          ), // Text(event.rules),
        ],
      ),
    );
  }

  String get _spotInfo {
    return event.spots.map((spot) => spot.name).toList().join(', ');
  }
}

class _EventName extends StatelessWidget {
  const _EventName({
    Key key,
    @required this.event,
  }) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Text(event.name, style: TextStyle(fontSize: 24.0));
  }
}

class _ChipList extends StatelessWidget {
  const _ChipList({
    Key key,
    @required this.items,
  }) : super(key: key);

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      children: items.map((item) => Chip(label: Text(item))).toList(),
    );
  }
}

class _HeadedText extends StatelessWidget {
  final String heading;
  final String content;

  _HeadedText({Key key, this.heading, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(heading,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(content),
        ),
      ],
    );
  }
}
