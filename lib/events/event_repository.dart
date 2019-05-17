import 'package:fest_app/events/models.dart';

/// Meant to be thrown when an entity could not be found in
/// the app's data-source.
class NotInDataSourceException implements Exception {
  final String message;

  NotInDataSourceException([this.message = '']);

  @override
  String toString() => 'NotInDataSourceException: $message';
}

/// The means through which we'll access our [Event]s data.
abstract class EventRepository {

  /// Gives the [Event]s which  satisfy the current filter.
  Stream<List<Event>> get filteredEvents;

  /// Gives all the [Spot]s known to the app.
  Stream<List<Spot>> get spots;

  /// Gives all the [Type]s known to the app.
  Stream<List<Type>> get types;

  /// Gives the event filter which is active.
  Stream<Filter> get filter;

  /// Sets the starred status of  the [Event] corresponding
  /// to [eventId] as per [starred].
  /// 
  /// Throws [NotInDataSourceException]  if  [eventId] does
  /// not correspond to an [Event].
  Future<void> setStarredStatus({int eventId, bool starred});

  /// Makes the event filter allow only those [Event]s that
  /// have atleast one [Spot] corresponding to  a [Spot] in
  /// [spotNames].
  /// 
  /// Throws [NotInDataSourceException] even if just one of
  /// the [spotNames] is non-existent in the data-source.
  Future<void> setSpotFilter({List<String> spotNames});

  /// Makes the event filter allow only those [Event]s that
  /// have atleast one [Type] corresponding to  a [Type] in
  /// [typeNames].
  /// 
  /// Throws [NotInDataSourceException] even if just one of
  /// the [typeNames] is non-existent in the data-source.
  Future<void> setTypeFilter({List<String> typeNames});

  /// If [enabled], makes the event filter allow only those
  /// [Event]s that are currently going on.
  Future<void> setOngoingOnlyFilter({bool enabled});

  /// If [enabled], makes the event filter allow only those
  /// [Event]s that're starred by the user.
  Future<void> setStarredOnlyFilter({bool enabled});
}