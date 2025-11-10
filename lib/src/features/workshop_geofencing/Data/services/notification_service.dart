import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



/// Callback function executed when a notification is tapped in the background.
///
/// This function is annotated with `@pragma('vm:entry-point')` to ensure it can be
/// executed in a separate isolate, which is necessary for background tasks.
/// It prints the payload of the tapped notification to the console.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // Handle background tap logic here
  print("Notification tapped in background: ${notificationResponse.payload}");
}

/// A singleton service for managing local notifications in the application.
///
/// This class provides methods to initialize the notification plugin,
/// configure notification details, and display notifications.
class NotificationService {
  /// Private constructor to enforce the singleton pattern.
  NotificationService._internal();

  /// The single instance of [NotificationService].
  static final NotificationService _instance = NotificationService._internal();

  /// Factory constructor to provide access to the singleton instance.
  ///
  /// Returns the [_instance] of [NotificationService].
  factory NotificationService() => _instance;

  /// The plugin instance for managing local notifications.
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  /// A flag indicating whether the notification service has been initialized.
  bool _isInitialized = false;
  /// Getter to check if the notification service is initialized.
  bool get isInit => _isInitialized;

  /// Initializes the local notification service.
  ///
  /// This method configures the Android and iOS notification settings
  /// and initializes the [FlutterLocalNotificationsPlugin].
  /// It also sets up the [notificationTapBackground] callback for background taps.
  /// This method will only run once even if called multiple times.
  Future<void> initNotification() async {
    if (_isInitialized) return; // prevent reinitialization
    // prepare android init setting
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    // prepare iOS init setting
    const iosSetting = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    //init settings
    const initSetting = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );
    // Initialize the plugin with the defined settings and background callback.
    await notificationPlugin.initialize(
      initSetting,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    _isInitialized = true;
  }

  /// Provides the default [NotificationDetails] for displaying notifications.
  ///
  /// This getter configures the Android and iOS specific notification details,
  /// including channel ID, name, description, importance, priority, and icon
  /// for Android, and basic settings for iOS.
  /// The Android notification uses a [BigTextStyleInformation] to allow for longer body text.
  NotificationDetails get notificationDetails {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'CAS_Channel_ID',
        'CAS Time Tracker',
        channelDescription: 'For CAS Time Tracking Notifications',
        importance: Importance.max,
        priority: Priority.max,
        icon: '@mipmap/ic_launcher',
        styleInformation: BigTextStyleInformation(''),
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  /// Displays a local notification.
  ///
  /// [id]: A unique integer identifier for the notification.
  /// [title]: The title of the notification.
  /// [body]: The main content text of the notification.
  /// [payload]: (Optional) A string payload associated with the notification,
  /// defaulting to "open_app". This payload can be retrieved when the notification is tapped.
  Future<void> showNotification(int id, String title, String body,{String payload = "open_app"}) async {
    try {
      await notificationPlugin.show(
        id,
        title,
        body,
        notificationDetails,
        payload: 'open_app',
      );
    } catch (e) {}
    debugPrint("Notification notification shown");
  }
}
