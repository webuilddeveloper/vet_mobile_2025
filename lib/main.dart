import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vet/home_V2.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/splash.dart';
import 'package:vet/version.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final appLinks = AppLinks();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await initializeDateFormatting('th');

  LineSDK.instance.setup('1655337910');

  HttpOverrides.global = MyHttpOverrides();

  runApp(MyApp());

  // ย้าย initUniLinks มาหลังจาก runApp
  initAppLinks();
}

Future<void> initAppLinks() async {
  print('---------- initAppLinks ----------');

  try {
    // รับลิงก์ตอนเปิดแอปครั้งแรก (initial link)
    final initialUri = await appLinks.getInitialLink();
    if (initialUri != null) {
      print('---------- initialUri ---------- $initialUri');

      // แปลงเป็น Uri แล้วดึงพารามิเตอร์
      Uri? uri = initialUri;
      String? code = uri.queryParameters['code'];
      String? state = uri.queryParameters['state'];

      if (code != null && state != null) {
        print('Code: $code');
        print('State: $state');

        if (state == 'profile') {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => SplashPage()),
          );
        } else if (state == 'login') {
          Dio dio = Dio();
          var response = await dio.post(
            '${server}m/v2/register/thaid/login',
            data: {'ref_code': code},
          );

          if (response.data['status'] == 'S') {
            new TextEditingController().clear();
            createStorageApp(
              model: response.data['objectData'],
              category: 'guest',
            );

            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => HomePageV2()),
            );
          }
        }
      } else {
        print('Missing parameters: code or state');
      }
    }
  } catch (e) {
    print('Error handling initial app link: $e');
  }

  // ฟัง stream ลิงก์ขณะแอปรันอยู่
  appLinks.uriLinkStream.listen((Uri? uri) async {
    if (uri != null) {
      print('---------- uriLinkStream ---------- $uri');

      String? code = uri.queryParameters['code'];
      String? state = uri.queryParameters['state'];

      if (code != null && state != null) {
        print('Code: $code');
        print('State: $state');

        if (state == 'profile') {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => SplashPage()),
          );
        } else if (state == 'login') {
          Dio dio = Dio();
          var response = await dio.post(
            '${server}m/v2/register/thaid/login',
            data: {'ref_code': code},
          );

          if (response.data['status'] == 'S') {
            new TextEditingController().clear();
            createStorageApp(
              model: response.data['objectData'],
              category: 'guest',
            );

            navigatorKey.currentState?.pushReplacement(
              MaterialPageRoute(builder: (context) => HomePageV2()),
            );
          }
        }
      } else {
        print('Missing parameters: code or state');
      }
    } else {
      print('Received null URI');
    }
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: Color(0xFF99722F),
        fontFamily: 'Kanit',
      ),
      title: 'สัตวแพทยสภา',
      home: VersionPage(),
    );
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
