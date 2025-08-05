// import 'dart:convert';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:http/http.dart' as http;
// import 'package:vet/pages/event_calendar/event_calendar_form.dart';
// import 'package:vet/pages/knowledge/knowledge_form.dart';
// import 'package:vet/pages/news/news_form.dart';
// import 'package:vet/pages/poll/poll_form.dart';
// import 'package:vet/pages/privilege/privilege_form.dart';

// import 'api_provider.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   '9999', // id
//   'your channel name', // title
//   // 'This channel is used for important notifications.', // description
//   importance: Importance.high,
//   playSound: true,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // await Firebase.initializeApp();
//   print('A bg message just showed up :  ${message.messageId}');
// }

// class NotificationService {
//   /// We want singelton object of ``NotificationService`` so create private constructor
//   /// Use NotificationService as ``NotificationService.instance``
//   NotificationService._internal();

//   static final NotificationService instance = NotificationService._internal();
//   bool _started = false;
//   void start(BuildContext context) {
//     if (!_started) {
//       _integrateNotification(context);
//       _refreshToken();
//       _started = true;
//     }
//   }

//   Future<void> _refreshToken() async {
//     // var token = await FirebaseMessaging.instance.getToken();
//     // print('token: $token');
//     // final storage = new FlutterSecureStorage();
//     // storage.write(key: 'token', value: token);
//     FirebaseMessaging.instance.getToken().then((token) async {
//       print('token: $token');

//       final storage = new FlutterSecureStorage();
//       storage.write(key: 'token', value: token);

//       String? value = await storage.read(key: 'dataUserLoginDDPM');
//       if ((value ?? '') != '') {
//         print(value);
//         dynamic userModel = json.decode(value!);
//         print(userModel['username']);
//         var body = json.encode({
//           'token': token,
//           'username': userModel['username'],
//         });
//         http.post(Uri.parse('${server}/m/register/token/create'),
//             body: body,
//             headers: {
//               "Accept": "application/json",
//               "Content-Type": "application/json"
//             });
//       }
//       // String appBadgeSupported;
//       // bool res = await FlutterAppBadger.isAppBadgeSupported();
//       // if (res) {
//       //   appBadgeSupported = 'Supported';
//       // } else {
//       //   appBadgeSupported = 'Not supported';
//       // }
//       // print('=-------------------------------$appBadgeSupported');
//       // FlutterAppBadger.updateBadgeCount(2);
//     }, onError: _tokenRefreshFailure);
//   }

//   void _tokenRefresh(String newToken) async {
//     // print('New Token : $newToken');

//     final storage = new FlutterSecureStorage();
//     storage.write(key: 'token', value: newToken);
//     String? value = await storage.read(key: 'dataUserLoginDDPM');
//     if ((value ?? '') != '') {
//       print(value);
//       dynamic userModel = json.decode(value!);
//       print(userModel['username']);
//       var body = json.encode({
//         'token': newToken,
//         'username': userModel['username'],
//       });
//       http.post(Uri.parse('${server}/m/register/token/create'),
//           body: body,
//           headers: {
//             "Accept": "application/json",
//             "Content-Type": "application/json"
//           });
//     }
//   }

//   void _tokenRefreshFailure(error) {
//     print("FCM token refresh failed with error $error");
//   }

//   void _integrateNotification(BuildContext context) {
//     _initializeLocalNotification();
//     _registerNotification(context);
//   }

//   Future<void> _initializeLocalNotification() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//     await FirebaseMessaging.instance.subscribeToTopic('all');
//   }

//   void _registerNotification(BuildContext context) {
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _updateBagder(message);

//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(
//                 channel.id,
//                 channel.name,
//                 // channel.description,
//                 color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher',
//               ),
//             ));
//       }
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//       print('A new onMessageOpenedApp event was published!');
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       // if (notification != null && android != null) {
//       //   print('----------1-------------${message.data['page']}');
//       //   showDialog(
//       //       context: context,
//       //       builder: (_) {
//       //         return AlertDialog(
//       //           title: Text(notification.title),
//       //           content: SingleChildScrollView(
//       //             child: Column(
//       //               crossAxisAlignment: CrossAxisAlignment.start,
//       //               children: [Text(notification.body)],
//       //             ),
//       //           ),
//       //         );
//       //       });
//       // } else {
//       print('----------2---------${message.data['page']}');
//       switch (message.data['page']) {
//         case 'NEWS':
//           {
//             var _newsPage = await postDio('${newsApi}read',
//                 {'skip': 0, 'limit': 1, 'code': message.data['code']});
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => NewsForm(
//                   code: message.data['code'],
//                   model: _newsPage[0],
//                 ),
//               ),
//             );
//           }
//           break;

//         case 'EVENTTCALENDAR':
//           {
//             var _eventPage = await postDio('${eventCalendarApi}read',
//                 {'skip': 0, 'limit': 1, 'code': message.data['code']});
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => EventCalendarForm(
//                   code: message.data['code'],
//                   model: _eventPage[0],
//                 ),
//               ),
//             );
//           }
//           break;
//         case 'PRIVILEGE':
//           {
//             var _privilegePage = await postDio('${privilegeApi}read',
//                 {'skip': 0, 'limit': 1, 'code': message.data['code']});
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PrivilegeForm(
//                   code: message.data['code'],
//                   model: _privilegePage[0],
//                 ),
//               ),
//             );
//           }
//           break;

//         case 'KNOWLEDGE':
//           {
//             var _knowledgePage = await postDio('${knowledgeApi}read',
//                 {'skip': 0, 'limit': 1, 'code': message.data['code']});
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => KnowledgeForm(
//                   code: message.data['code'],
//                   model: _knowledgePage[0],
//                 ),
//               ),
//             );
//           }
//           break;
//         case 'POLL':
//           {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => PollForm(
//                   code: message.data['code'],
//                   // model: message,
//                 ),
//               ),
//             );
//           }
//           break;
//         default:
//           {
//             showDialog(
//                 context: context,
//                 builder: (_) {
//                   return AlertDialog(
//                     title: Text(notification?.title ?? ''),
//                     content: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [Text(notification?.body ?? '')],
//                       ),
//                     ),
//                   );
//                 });
//           }
//           break;
//       }
//       // }
//     });

//     FirebaseMessaging.instance.onTokenRefresh
//         .listen(_tokenRefresh, onError: _tokenRefreshFailure);
//   }

//   _updateBagder(message) async {
//     dynamic _isNewsCount = false;
//     dynamic _isEventCount = false;
//     dynamic _isPollCount = false;
//     dynamic _isPrivilegeCount = false;

//     if (message['page'] == "NEWS")
//       _isNewsCount = true;
//     else
//       _isNewsCount =
//           await storage.read(key: 'isBadgerNews') == '1' ? true : false;

//     if (message['page'] == "EVENTTCALENDAR")
//       _isEventCount = true;
//     else
//       _isEventCount =
//           await storage.read(key: 'isBadgerEvent') == '1' ? true : false;

//     if (message['page'] == "POLL")
//       _isPollCount = true;
//     else
//       _isPollCount =
//           await storage.read(key: 'isBadgerPoll') == '1' ? true : false;

//     if (message['page'] == "PRIVILEGE")
//       _isPrivilegeCount = true;
//     else
//       _isPrivilegeCount =
//           await storage.read(key: 'isBadgerPrivilege') == '1' ? true : false;

//     int add_badger = 0;
//     if (_isNewsCount && _isEventCount && _isPollCount && _isPrivilegeCount)
//       add_badger = 4;
//     else if ((_isNewsCount && _isEventCount && _isPollCount) ||
//         (_isNewsCount && _isEventCount && _isPrivilegeCount) ||
//         (_isNewsCount && _isPollCount && _isPrivilegeCount) ||
//         (_isEventCount && _isPollCount && _isPrivilegeCount))
//       add_badger = 3;
//     else if ((_isNewsCount && _isEventCount) ||
//         (_isNewsCount && _isPollCount) ||
//         (_isNewsCount && _isPrivilegeCount) ||
//         (_isPollCount && _isEventCount) ||
//         (_isPollCount && _isPrivilegeCount) ||
//         (_isEventCount && _isPrivilegeCount))
//       add_badger = 2;
//     else if (_isNewsCount || _isEventCount || _isPollCount || _isPrivilegeCount)
//       add_badger = 1;
//     else
//       add_badger = 0;
//     _updateBadgerStorage('isBadgerNews', _isNewsCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerEvent', _isEventCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerPoll', _isPollCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerPrivilege', _isPrivilegeCount ? '1' : '0');

//     FlutterAppBadger.updateBadgeCount(add_badger);
//   }

//   final storage = new FlutterSecureStorage();
//   _updateBadgerStorage(String keyTitle, String isActive) {
//     storage.write(
//       key: keyTitle,
//       value: isActive,
//     );
//   }

//   void showNotification() {
//     flutterLocalNotificationsPlugin.show(
//         0,
//         "Testing ",
//         "How you doin ?",
//         NotificationDetails(
//             android: AndroidNotificationDetails(channel.id, channel.name,
//                 importance: Importance.high,
//                 // color: Colors.blue,
//                 playSound: true,
//                 icon: '@mipmap/ic_launcher')));
//   }

//   // Call this method to initialize notification
// }
