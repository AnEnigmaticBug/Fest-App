/// Gives a string containing [dateTime]'s information in
/// a pretty way.
/// 
/// The time is in 24-hour format. Both hours and minutes
/// will be prepadded by '0' if they're single-digit.
/// 
/// An example output is 'THU 22:15'.
String prettyPrintDateTime(DateTime dateTime) {
  final hours = dateTime.hour.toString().padLeft(2, '0');
  final minutes = dateTime.minute.toString().padLeft(2, '0');

  String weekDay;
    switch (dateTime.weekday) {
      case DateTime.monday:
        weekDay = 'MON';
        break;
      case DateTime.tuesday:
        weekDay = 'TUE';
        break;
      case DateTime.wednesday:
        weekDay = 'WED';
        break;
      case DateTime.thursday:
        weekDay = 'THU';
        break;
      case DateTime.friday:
        weekDay = 'FRI';
        break;
      case DateTime.saturday:
        weekDay = 'SAT';
        break;
      case DateTime.sunday:
        weekDay = 'SUN';
        break;
    }

  return '$weekDay $hours:$minutes';
}
