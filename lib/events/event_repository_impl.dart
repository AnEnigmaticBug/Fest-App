import 'package:meta/meta.dart';
import 'package:rxdart/subjects.dart';
import 'package:sqflite/sqflite.dart';

import 'package:fest_app/events/event_api.dart';
import 'package:fest_app/events/event_repository.dart';
import 'package:fest_app/events/models.dart';

export 'package:fest_app/events/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final Database _db;
  final EventApi _eventApi;

  final _eventsSubject = BehaviorSubject<List<Event>>();
  final _spotsSubject = BehaviorSubject<List<Spot>>.seeded([]);
  final _typesSubject = BehaviorSubject<List<Type>>.seeded([]);
  final _filterSubject = BehaviorSubject<Filter>();

  final _eventsCache = Map<int, Event>();

  EventRepositoryImpl({@required Database db, @required EventApi eventApi})
      : _db = db,
        _eventApi = eventApi {
    _triggerFilter().then((_) async {
      await _triggerEvents();
      await _triggerSpots();
      await _triggerTypes();

      await _fetchEvents();

      await _triggerEvents();
      await _triggerSpots();
      await _triggerTypes();
    });
  }

  @override
  Stream<List<Event>> get filteredEvents => _eventsSubject.stream;

  @override
  Stream<List<Spot>> get spots => _spotsSubject.stream;

  @override
  Stream<List<Type>> get types => _typesSubject.stream;

  @override
  Stream<Filter> get filter => _filterSubject.stream;

  @override
  Future<void> setStarredStatus({int eventId, bool starred}) async {
    final count = await _db.rawUpdate('''
      UPDATE Event
         SET isStarred = ?
       WHERE id = ?
    ''', [starred ? 1 : 0, eventId]);

    if (count == 0) {
      throw NotInDataSourceException();
    }

    final filter = _filterSubject.value;

    if (filter.showOnlyStarred && !starred) {
      _eventsCache.remove(eventId);
    } else if (_eventsCache.containsKey(eventId)) {
      _eventsCache[eventId] = Event(
        id: eventId,
        name: _eventsCache[eventId].name,
        about: _eventsCache[eventId].about,
        rules: _eventsCache[eventId].rules,
        spots: _eventsCache[eventId].spots,
        types: _eventsCache[eventId].types,
        dateTime: _eventsCache[eventId].dateTime,
        duration: _eventsCache[eventId].duration,
        isStarred: starred,
      );
    }

    _eventsSubject.add(_eventsCache.values.toList());

    await _triggerEvents();
  }

  @override
  Future<void> setSpotFilter({List<String> spotNames}) async {
    await _db.transaction((txn) async {
      for (var name in spotNames) {
        final rows = await txn.rawQuery('''
          SELECT name
            FROM EventSpot
           WHERE name = ?
        ''', [name]);

        if (rows.isEmpty) {
          throw NotInDataSourceException();
        }

        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventFilterAndSpot(spotName)
          VALUES (?)
        ''', [name]);
      }
    });

    await _triggerEvents();
  }

  @override
  Future<void> setTypeFilter({List<String> typeNames}) async {
    await _db.transaction((txn) async {
      for (var name in typeNames) {
        final rows = await txn.rawQuery('''
          SELECT name
            FROM EventType
           WHERE name = ?
        ''', [name]);

        if (rows.isEmpty) {
          throw NotInDataSourceException();
        }

        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventFilterAndType(typeName)
          VALUES (?)
        ''', [name]);
      }
    });

    await _triggerEvents();
  }

  @override
  Future<void> setOngoingOnlyFilter({bool enabled}) async {
    await _db.rawUpdate('''
      UPDATE EventFilter
         SET ongoingOnly = ?
    ''', [enabled ? 1 : 0]);

    await _triggerEvents();
  }

  @override
  Future<void> setStarredOnlyFilter({bool enabled}) async {
    await _db.rawUpdate('''
      UPDATE EventFilter
         SET starredOnly = ?
    ''', [enabled ? 1 : 0]);

    await _triggerEvents();
  }

  Future<void> _triggerEvents() async {
    await _db.transaction((txn) async {
      _eventsCache.clear();

      final eventRows = await txn.rawQuery('''
        SELECT *
          FROM Event
      ''');

      final result = <Event>[];

      for (var eventRow in eventRows) {
        final eventId = eventRow['id'];

        final spotRows = await txn.rawQuery('''
          SELECT spotName
            FROM EventAndSpot
           WHERE eventId = ?
        ''', [eventId]);

        final spots =
            spotRows.map((row) => Spot(name: row['spotName'])).toList();

        final typeRows = await txn.rawQuery('''
          SELECT typeName
            FROM EventAndType
           WHERE eventId = ?
        ''', [eventId]);

        final types =
            typeRows.map((row) => Type(name: row['typeName'])).toList();

        final event = Event(
            id: eventId,
            name: eventRow['name'],
            about: eventRow['about'],
            rules: eventRow['rules'],
            spots: spots,
            types: types,
            dateTime: DateTime.parse(eventRow['dateTime']),
            duration: eventRow['duration'],
            isStarred: eventRow['isStarred'] == 1);

        if (_filterSubject.value.allows(event)) {
          _eventsCache[event.id] = event;
          result.add(event);
        }
      }

      _eventsSubject.add(result);
    });
  }

  Future<void> _triggerSpots() async {
    final rows = await _db.rawQuery('''
      SELECT name
        FROM EventSpot
    ''');

    final result = rows.map((row) => Spot(name: row['name'])).toList();
    _spotsSubject.add(result);
  }

  Future<void> _triggerTypes() async {
    final rows = await _db.rawQuery('''
      SELECT name
        FROM EventType
    ''');

    final result = rows.map((row) => Type(name: row['name'])).toList();
    _typesSubject.add(result);
  }

  Future<void> _triggerFilter() async {
    await _db.transaction((txn) async {
      final row = (await txn.rawQuery('''
        SELECT ongoingOnly, starredOnly
          FROM EventFilter
      ''')).first;

      final showOnlyOngoing = row['ongoingOnly'] == 1;
      final showOnlyStarred = row['starredOnly'] == 1;

      final spots = (await txn.rawQuery('''
        SELECT *
          FROM EventFilterAndSpot
      ''')).map<Spot>((row) => Spot(name: row['spotName'])).toList();

      final types = (await txn.rawQuery('''
        SELECT *
          FROM EventFilterAndType
      ''')).map<Type>((row) => Type(name: row['typeName'])).toList();

      _filterSubject.add(Filter(
          showOnlyOngoing: showOnlyOngoing,
          showOnlyStarred: showOnlyStarred,
          spots: spots,
          types: types));
    });
  }

  Future<void> _fetchEvents() async {
    final freshEvents = await _eventApi.events;

    await _db.transaction((txn) async {
      final freshEventIds = freshEvents.map((event) => event.id).toList();

      final localEventIds = (await txn.rawQuery('''
        SELECT id
          FROM Event
      ''')).map<int>((row) => row['id']).toList();

      await _deleteEventsByIds(txn, minus(localEventIds, freshEventIds));

      final eventsToBeInserted = freshEvents
          .where((event) => !localEventIds.contains(event.id))
          .toList();

      await _insertEvents(txn, eventsToBeInserted);

      final eventsToBeUpdated = freshEvents
          .where((event) => localEventIds.contains(event.id))
          .toList();

      await _updateEvents(txn, eventsToBeUpdated);
    });
  }

  Future<void> _deleteEventsByIds(Transaction txn, List<int> eventIds) async {
    if (eventIds.isEmpty) {
      return;
    }

    final sqlIdList =
        '(' + List.generate(eventIds.length - 1, (_) => '?, ').join('') + '?)';

    await txn.rawDelete('''
      DELETE FROM Event
       WHERE id IN $sqlIdList
    ''', eventIds);
  }

  Future<void> _insertEvents(Transaction txn, List<Event> events) async {
    for (var event in events) {
      for (var spot in event.spots) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventSpot(name)
          VALUES (?)
        ''', [spot.name]);
      }

      for (var type in event.types) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventType(name)
          VALUES (?)
        ''', [type.name]);
      }

      await txn.rawInsert('''
        INSERT INTO Event(id, name, about, rules, dateTime, duration, prize, isStarred)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ''', [
        event.id,
        event.name,
        event.about,
        event.rules,
        event.dateTime.toIso8601String(),
        event.duration,
        event.prize,
        0
      ]);

      for (var spot in event.spots) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventAndSpot(eventId, spotName)
          VALUES (?, ?)
        ''', [event.id, spot.name]);
      }

      for (var type in event.types) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventAndType(eventId, typeName)
          VALUES (?, ?)
        ''', [event.id, type.name]);
      }
    }
  }

  Future<void> _updateEvents(Transaction txn, List<Event> events) async {
    for (var event in events) {
      for (var spot in event.spots) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventSpot(name)
          VALUES (?)
        ''', [spot.name]);
      }

      for (var type in event.types) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventType(name)
          VALUES (?)
        ''', [type.name]);
      }

      await txn.rawUpdate('''
        UPDATE Event
           SET name = ?, about = ?, rules = ?, dateTime = ?, duration = ?, prize = ?
         WHERE id = ?
      ''', [
        event.name,
        event.about,
        event.rules,
        event.dateTime?.toIso8601String(),
        event.duration,
        event.prize,
        event.id
      ]);

      await txn.rawDelete('''
        DELETE FROM EventAndSpot
         WHERE eventId = ?
      ''', [event.id]);

      for (var spot in event.spots) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventAndSpot(eventId, spotName)
          VALUES (?, ?)
        ''', [event.id, spot.name]);
      }

      await txn.rawDelete('''
        DELETE FROM EventAndType
         WHERE eventId = ?
      ''', [event.id]);

      for (var type in event.types) {
        await txn.rawInsert('''
          INSERT OR IGNORE INTO EventAndType(eventId, typeName)
          VALUES (?, ?)
        ''', [event.id, type.name]);
      }
    }
  }

  List<T> minus<T>(List<T> a, List<T> b) {
    return a.where((elem) => !b.contains(elem)).toList();
  }
}
