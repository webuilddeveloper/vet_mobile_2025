import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp();
  await initializeDateFormatting('th');

  LineSDK.instance.setup('1655337910');

  HttpOverrides.global = MyHttpOverrides();
  
  runApp(MyApp());

  // ย้าย initUniLinks มาหลังจาก runApp
  initUniLinks();
}


Future<void> initUniLinks() async {
  try {
    print('---------- initUniLinks ----------');

    try {
      String? initialLink = await getInitialLink(); // รับค่าที่เป็น String?
      if (initialLink != null) {
        // จัดการ deep link
        print('---------- initialLink ----------' + initialLink.toString());

        // แปลง initialLink เป็น Uri
        Uri uri = Uri.parse(initialLink);

        // ตรวจสอบว่ามีพารามิเตอร์ 'code' และ 'state' หรือไม่
        String? code = uri.queryParameters['code'];
        String? state = uri.queryParameters['state'];

        // ตรวจสอบว่า 'code' และ 'state' มีค่าไม่เป็น null ก่อนใช้งาน
        if (code != null && state != null) {
          print('Code: $code');
          print('State: $state');
          // ดำเนินการตามค่าที่ได้รับจาก code และ state
        } else {
          print('Missing parameters: code or state');
        }

        // การตรวจสอบค่าของ 'state'
        if (state == 'profile') {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => SplashPage()),
          );
        } else if (state == 'login') {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => SplashPage()),
          );
        }
      }
    } catch (e) {
      print('Error handling uni links: $e');
    }
    uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        // จัดการ deep link ที่ได้รับ
        print('---------- uriLinkStream ----------' + uri.toString());

        // Get the code and state from the URI parameters
        String? code = uri.queryParameters['code'];
        String? state = uri.queryParameters['state'];

        if (code != null && state != null) {
          print('Code: $code');
          print('State: $state');
          // ดำเนินการตามค่าที่ได้รับจาก code และ state
        } else {
          print('Missing parameters: code or state');
        }

        // ตรวจสอบ state และทำการนำทางไปยังหน้าต่างๆ
        if (state == 'profile') {
          navigatorKey.currentState?.pushReplacement(
            MaterialPageRoute(builder: (context) => SplashPage()),
          );
        } else if (state == 'login') {
          Dio dio = Dio();
          var response = await dio.post(
            '${server}m/v2/register/thaid/login',
            data: {'ref_code': code.toString()},
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
        print('Received null URI');
      }
    });
  } on PlatformException {
    // Handle error
    print('---------- Error DeepLink ----------');
  }
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
