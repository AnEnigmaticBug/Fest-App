import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:fest_app/shared/constants.dart';
import 'package:fest_app/events/models.dart';

class HttpException implements Exception {
  final String message;

  HttpException([this.message = '']);

  @override
  String toString() => 'HttpException: $message';
}

/// The means through which we will get our [Event]s data.
class EventApi {
  Future<List<Event>> get events async {
    final response = await http.get('$baseUrl/registrations/events/');

    if (response.statusCode != 200) {
      throw HttpException('${response.statusCode}');
    }

    final rawEventList = json.decode(response.body);
    if (rawEventList is! List<dynamic>) {
      throw FormatException('Malformed JSON');
    }

    final result = <Event>[];

    for (var rawEvent in rawEventList) {
      try {
        final event = _convertToEvent(rawEvent);
        result.add(event);
      } on FormatException catch (e) {
        print(e);
      }
    }

    return result;
  }

  Event _convertToEvent(Map<String, dynamic> rawEvent) {
    final id = rawEvent['id'];
    if (id == null || id is! int) {
      throw FormatException('Missing id');
    }
    final name = rawEvent['name'];
    if (name == null || name is! String) {
      throw FormatException('Missing name');
    }
    final about = rawEvent['about'];
    if (about == null || about is! String) {
      throw FormatException('Missing about');
    }
    final rules = rawEvent['rules'];
    if (rules == null || rules is! String) {
      throw FormatException('Missing rules');
    }
    final spotNames = rawEvent['venue'];
    if (spotNames == null || spotNames is! String) {
      throw FormatException('Missing spots');
    }
    final typeNames = rawEvent['categories'];
    if (typeNames == null || typeNames is! List<dynamic>) {
      throw FormatException('Missing types');
    }
    final dateTime = rawEvent['date_time'];
    if (dateTime == null || dateTime is! String) {
      throw FormatException('Missing dateTime');
    }
    final duration = rawEvent['duration'];
    if (duration == null || duration is! int) {
      throw FormatException('Missing duration');
    }

    return Event(
      id: id,
      name: name,
      about: about,
      rules: rules,
      spots: [Spot(name: spotNames)],
      types: typeNames.map<Type>((typeName) => Type(name: typeName)).toList(),
      dateTime: DateTime.parse(dateTime),
      duration: duration,
      isStarred: false,
    );
  }
}
