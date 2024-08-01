import '../../constants/enums.dart';

class Reminder {
  final String plantName;
  final CareType careType;
  final DateTime lastCaregDateTime;
  final DateTime nextCaregDateTime;
  final int days;
  final int hours;
  final String id;
  final int notificationId;

  Reminder({
    required this.plantName,
    required this.careType,
    required this.lastCaregDateTime,
    required this.nextCaregDateTime,
    required this.days,
    required this.hours,
    required this.id,
    required this.notificationId,
  });
}
