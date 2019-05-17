import 'package:meta/meta.dart';

/// Represents an event in the fest.
class Event {
  final int id;
  final String name;
  final String about;
  final String rules;
  final List<Spot> spots;
  final List<Type> types;
  final DateTime dateTime;
  final int duration;
  final String prize;
  final bool isStarred;

  Event({
    @required this.id,
    @required this.name,
    this.about = '',
    this.rules = '',
    this.spots = const [],
    this.types = const [],
    @required this.dateTime,
    @required this.duration,
    this.prize = 'Nothing',
    this.isStarred = false,
  });
}

/// Represents a spot on which an event my be organized.
class Spot {
  final String name;

  Spot({
    @required this.name,
  });
}

/// Represents a type/category which an event can be of.
class Type {
  final String name;

  Type({
    @required this.name,
  });
}

/// Represents a filter config which the user can apply.
class Filter {
  final bool showOnlyOngoing;
  final bool showOnlyStarred;
  final List<Spot> spots;
  final List<Type> types;

  Filter({
    this.showOnlyOngoing = false,
    this.showOnlyStarred = false,
    this.spots = const [],
    this.types = const [],
  });

  bool allows(Event event) {
    if (showOnlyStarred && !event.isStarred) {
      return false;
    }

    if (showOnlyOngoing) {
      final min = event.dateTime;
      final max = event.dateTime.add(Duration(minutes: event.duration));
      final now = DateTime.now();

      if (now.isBefore(min) || now.isAfter(max)) {
        return false;
      }
    }

    if (spots.isNotEmpty && !_atleastOneCommonItem(spots, event.spots)) {
      return false;
    }

    if (types.isNotEmpty && !_atleastOneCommonItem(types, event.types)) {
      return false;
    }

    return true;
  }

  bool _atleastOneCommonItem<T>(List<T> listA, List<T> listB) {
    for (var a in listA) {
      if (listB.contains(a)) {
        return true;
      }
    }

    return false;
  }
}
