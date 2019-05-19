import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fest_app/events/event_repository.dart';
import 'package:fest_app/events/models.dart';
import 'package:fest_app/events/star_button.dart';
import 'package:fest_app/shared/util.dart';

class EventTile extends StatelessWidget {
  final Event event;

  EventTile({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _EventName(event: event),
                  SizedBox(height: 2.0),
                  _EventMinorDetails(event: event)
                ],
              ),
            ),
            StarButton(
              isStarred: event.isStarred,
              onToggled: (wasStarred) {
                Provider.of<EventRepository>(context)
                    .setStarredStatus(eventId: event.id, starred: !wasStarred);
              },
            )
          ],
        ),
      ),
      onTap: () {},
    );
  }
}

class _EventName extends StatelessWidget {
  final Event event;

  const _EventName({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      event.name,
      style: TextStyle(fontSize: 20.0, color: Colors.white),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _EventMinorDetails extends StatelessWidget {
  final minorStyle = TextStyle(fontSize: 12.0, color: Colors.white);
  final Event event;

  _EventMinorDetails({Key key, @required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Text(
            prettyPrintDateTime(event.dateTime),
            style: minorStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: Text(
            _spotInfo,
            style: minorStyle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String get _spotInfo {
    return event.spots.map((spot) => spot.name).toList().join(', ');
  }
}
