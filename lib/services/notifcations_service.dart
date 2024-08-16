import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:seen/main.dart';
import 'package:seen/screens/home/page/home.dart';
import 'package:seen/screens/chat/page/chat_page.dart';

class NotificationService {
  static const channelKeys = {
    'user_notifications': 'user_notifications',
  };

  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: channelKeys['user_notifications'],
          channelKey: channelKeys['user_notifications'],
          channelName: 'user_notifications',
          channelDescription: 'Chats Notifications',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
          // enableVibration: true, // Enable vibration
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: channelKeys['user_notifications'].toString(),
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    try {
      debugPrint('onActionReceivedMethod');
      debugPrint(
          'Payload: ${receivedAction.payload!['anotherUserId']}'); // للتحقق من أن الحمولة تحتوي على البيانات الصحيحة
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ChatPage(
            uid: receivedAction.payload!['anotherUserId'],
            fcToken: receivedAction.payload!['anotherFcToken'],
          ),
        ),
      );
    } catch (e) {
      print('eeeeeeeee=================== ${e}');
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final bool repeats = false,
    final DateTime? scheduledDate,
    final int? interval,
    final int? id,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id!,
        channelKey: 'user_notifications',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        wakeUpScreen: true,
        groupKey: 'chat_messages',
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar(
              weekday: scheduledDate!.weekday,
              hour: scheduledDate.hour,
              minute: scheduledDate.minute,
              second: scheduledDate.second,
              millisecond: 0,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              repeats: repeats,
              preciseAlarm: true,
              allowWhileIdle: true,
            )
          : null,
    );
  }

  static Future<void> showScheduleNotification({
    required final String title,
    required final String body,
    required final String chanelKay,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final bool repeats = false,
    final DateTime? scheduledDate,
    final int? interval,
    final int? id,
  }) async {
    assert(!scheduled || (scheduled && interval != null));
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id!,
        channelKey: channelKeys[chanelKay].toString(),
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        wakeUpScreen: true,
        groupKey: 'chat_messages',
        
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationCalendar(
              millisecond: 0,
              second: 0,
              minute: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              repeats: repeats,
              preciseAlarm: true,
              allowWhileIdle: true,
            )
          : null,
    );
  }

  static Future<void> cancelNotification(
      {required String channelKeysName}) async {
    await AwesomeNotifications().cancelNotificationsByChannelKey(
        channelKeys[channelKeysName].toString());
  }
}
