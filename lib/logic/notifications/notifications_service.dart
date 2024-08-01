import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationsService {
  void scheduleNotification({
    required DateTime dateTime,
    required String title,
    required String body,
    required int notificationId,
  }) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'basic_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar.fromDate(
          date: dateTime,
          preciseAlarm: true, // Ensure precise scheduling
          allowWhileIdle:
              // ignore: lines_longer_than_80_chars
              true, // Ensure notifications can be shown while the device is idle
        ));
  }

  void cancelScheduledNotification(int notificationId) {
    AwesomeNotifications().cancel(notificationId);
  }
}
