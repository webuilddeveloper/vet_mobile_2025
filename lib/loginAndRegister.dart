import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vet/auth/forgot_password.dart';
import 'package:vet/home_v2.dart';
import 'package:vet/register.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/shared/apple_firebase.dart';
import 'package:vet/shared/google_firebase.dart';
import 'package:vet/shared/line.dart';
import 'package:vet/widget/text_field.dart';


DateTime now = new DateTime.now();
void main() {
  // Intl.defaultLocale = 'th';
  runApp(LoginAndRegisterPage());
}

class LoginAndRegisterPage extends StatefulWidget {
  LoginAndRegisterPage({Key? key, this.title}) : super(key: key);
  final String? title;
  @override
  _LoginAndRegisterPageState createState() => _LoginAndRegisterPageState();
}

class _LoginAndRegisterPageState extends State<LoginAndRegisterPage> {
  final storage = new FlutterSecureStorage();
  bool isSwitchedMainPage = false;
  bool isLogin = true;

  String? _username;
  String? _password;
  String? _facebookID;
  String? _appleID;
  String? _googleID;
  String? _lineID;
  String? _email;
  String? _imageUrl;
  String? _category;
  String? _prefixName;
  String? _firstName;
  String? _lastName;

  String selectedType = '0';

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void initState() {
    setState(() {
      _username = "";
      _password = "";
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _category = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });
    super.initState();
  }

  @override
  void dispose() {
    txtUsername.dispose();
    txtPassword.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBackground();
  }

  _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background_login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: _buildScaffold(),
    );
  }

  _buildWillPopScope() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: _buildScaffold(),
    );
  }

  _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          children: [
            Center(
              child: Image.asset(
                "assets/logo.png",
                fit: BoxFit.contain,
                height: 80.0,
              ),
            ),
            Center(
              child: Text(
                'สัตวแพทยสภา',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 30),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Color(0xFF1EB7D7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedType = '0';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: selectedType == '0'
                                      ? Color(0xFF99722F)
                                      : Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: selectedType == '2'
                                        ? Color(0xFF7F7F7F)
                                        : Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedType = '2';
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: selectedType == '2'
                                      ? Color(0xFF99722F)
                                      : Colors.transparent,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'สมัครสมาชิก',
                                  style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: selectedType == '2'
                                        ? Color(0xFFFFFFFF)
                                        : Color(0xFF7F7F7F),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    selectedType == '0'
                        ? _buildCardSelected()
                        : RegisterPage(
                            username: "",
                            password: "",
                            facebookID: "",
                            appleID: "",
                            googleID: "",
                            lineID: "",
                            email: "",
                            imageUrl: "",
                            category: "guest",
                            prefixName: "",
                            firstName: "",
                            lastName: "",
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildThaiDButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color.fromARGB(
          255, 45, 55, 72), // ใช้ RGB และกำหนดค่า Alpha = 255 (ทึบเต็มที่)
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40,
        onPressed: () async {
          final Uri url = Uri.parse(
              'https://imauth.bora.dopa.go.th/api/v2/oauth2/auth/?response_type=code&client_id=eHVGUDRSM0pIZkpCZ2RHR3VMSzJCQTNjMzUyeENZbjY&redirect_uri=https://dlapp.we-builds.com/vet-thaid&scope=pid given_name middle_name family_name name given_name_en middle_name_en family_name_en name_en title&state=login');

          if (await canLaunchUrl(url) != null) {
            await launchUrl(
              url,
              mode: LaunchMode
                  .externalApplication, // ระบุให้เปิดในเบราว์เซอร์ภายนอก
            );
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icon_thaiID.png',
              width: 30,
            ),
            SizedBox(
              width: 5,
            ),
            new Text(
              'แอปพลิเคชัน ThaID',
              style: new TextStyle(
                fontSize: 15.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoginButton() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(10.0),
      color: Color(0xFF99722F),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40,
        onPressed: () {
          loginWithGuest();
        },
        child: new Text(
          'เข้าสู่ระบบ',
          style: new TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
      ),
    );
  }

  _buildForgotPasswordButton() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordPage(),
          ),
        );
      },
      child: Text(
        'ลืมรหัสผ่าน',
        style: new TextStyle(
          fontSize: 12.0,
          color: Color(0xFF99722F),
          // fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          decoration: TextDecoration.underline, // เพิ่มขีดเส้นใต้
        ),
      ),
    );
    // return Material(
    //   elevation: 5.0,
    //   borderRadius: BorderRadius.circular(10.0),
    //   color: Color(0xFFFFFFFF),
    //   child: MaterialButton(
    //     minWidth: MediaQuery.of(context).size.width,
    //     height: 0,
    //     onPressed: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => ForgotPasswordPage(),
    //         ),
    //       );
    //     },
    //     child: new Text(
    //       'ลืมรหัสผ่าน',
    //       style: new TextStyle(
    //         fontSize: 20.0,
    //         color: Color(0xFF99722F),
    //         fontWeight: FontWeight.normal,
    //         fontFamily: 'Kanit',
    //       ),
    //     ),
    //   ),
    // );
  }

  _buildDialog(String param) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          param,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFF000070),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _widgetText({String? title, double fontSize = 17}) {
    return Text(
      title!,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Kanit',
        fontWeight: FontWeight.w500,
      ),
    );
  }

  //login username / password
  Future<dynamic> login() async {
    if ((_username == null || _username == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'กรุณากรอกชื่อผู้ใช้',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else if ((_password == null || _password == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            'กรุณากรอกรหัสผ่าน',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else if (isLogin) {
      // print('----- start login -----');

      // String url = _category == 'guest'
      //     ? 'm/Register/login'
      //     : 'm/Register/${_category}/login';

      // print('----- url ----- $url');

      // final result = await postLoginRegister(url, {
      //   'username': _username.toString(),
      //   'password': _password.toString(),
      //   'category': _category.toString(),
      //   'email': _email.toString(),
      // });
      setState(() {
        isLogin = false;
      });
      Dio dio = new Dio();
      var response = await dio.post(
        '${server}m/register/login',
        data: {
          'username': _username.toString(),
          'password': _password.toString()
        },
      );
      // print('----- response ----- ${response.toString()}');
      setState(() {
        isLogin = true;
      });
      if (response.data['status'] == 'S') {
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        createStorageApp(
          model: response.data['objectData'],
          category: 'guest',
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageV2(),
          ),
        );
      } else {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
              'ชื่อผู้ใช้งาน/รหัสผ่าน ไม่ถูกต้อง',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: Text(" "),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ตกลง",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF000070),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  new TextEditingController().clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }

      // if (result.status == 'S' || result.status == 's') {
      //   createStorageApp(
      //     model: result.objectData.code,
      //     category: 'guest',
      //   );

      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomePageV2(),
      //     ),
      //   );

      //   // await storage.write(
      //   //   key: 'dataUserLoginDDPM',
      //   //   value: jsonEncode(result.objectData),
      //   // );

      //   // Navigator.of(context).pushAndRemoveUntil(
      //   //   MaterialPageRoute(
      //   //     builder: (context) => HomePageV2(),
      //   //   ),
      //   //   (Route<dynamic> route) => false,
      //   // );
      // }

      // else {
      //   if (_category == 'guest') {
      //     return showDialog(
      //       barrierDismissible: false,
      //       context: context,
      //       builder: (BuildContext context) => new CupertinoAlertDialog(
      //         title: new Text(
      //           result.message,
      //           style: TextStyle(
      //             fontSize: 16,
      //             fontFamily: 'Kanit',
      //             color: Colors.black,
      //             fontWeight: FontWeight.normal,
      //           ),
      //         ),
      //         content: Text(" "),
      //         actions: [
      //           CupertinoDialogAction(
      //             isDefaultAction: true,
      //             child: new Text(
      //               "ตกลง",
      //               style: TextStyle(
      //                 fontSize: 13,
      //                 fontFamily: 'Kanit',
      //                 color: Color(0xFF000070),
      //                 fontWeight: FontWeight.normal,
      //               ),
      //             ),
      //             onPressed: () {
      //               Navigator.of(context).pop();
      //             },
      //           ),
      //         ],
      //       ),
      //     );
      //   } else {
      //     register();
      //   }
      // }
    }
  }

  Future<dynamic> register() async {
    final result = await postLoginRegister('m/Register/create', {
      'username': _username,
      'password': _password,
      'category': _category,
      'email': _email,
      'facebookID': _facebookID,
      'appleID': _appleID,
      'googleID': _googleID,
      'lineID': _lineID,
      'imageUrl': _imageUrl,
      'prefixName': _prefixName,
      'firstName': _firstName,
      'lastName': _lastName,
      'status': "N",
      'platform': Platform.operatingSystem.toString(),
      'birthDay': "",
      'phone': "",
      'countUnit': "[]"
    });

    if (result.status == 'S') {
      await storage.write(
        key: 'dataUserLoginDDPM',
        value: jsonEncode(result.objectData),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => HomePageV2(),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => new CupertinoAlertDialog(
          title: new Text(
            result.message ?? '',
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(" "),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: new Text(
                "ตกลง",
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Color(0xFF000070),
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  //login guest
  void loginWithGuest() async {
    setState(() {
      _category = 'guest';
      _username = txtUsername.text;
      _password = txtPassword.text;
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });
    login();
  }

  _buildCardSelected() {
    return Column(
      children: [
        Row(
          children: [
            _widgetText(title: 'เข้าสู่ระบบผ่านบัญชีโชเชียล'),
          ],
        ),
        _buildLoginSocial(),
        SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF99722F),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 2,
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            _widgetText(title: 'เข้าสู่ระบบผ่านบัญชี'),
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        labelTextField(
          'ชื่อผู้ใช้งาน',
          Icon(
            Icons.person,
            color: Color(0xFF99722F),
            size: 20.00,
          ),
        ),
        SizedBox(height: 5.0),
        textFieldLogin(
          model: txtUsername,
          hintText: 'ชื่อผู้ใช้งาน',
          labelText: 'ชื่อผู้ใช้งาน',
        ),
        SizedBox(height: 15.0),
        labelTextField(
          'รหัสผ่าน',
          Icon(
            Icons.lock,
            color: Color(0xFF99722F),
            size: 20.00,
          ),
        ),
        SizedBox(height: 5.0),
        textField(
          txtPassword,
          null,
          'รหัสผ่าน',
          'รหัสผ่าน',
          true,
          true,
        ),
        SizedBox(
          height: 20.0,
        ),
        _buildLoginButton(),
        SizedBox(
          height: 10.0,
        ),
        _buildForgotPasswordButton(),
        SizedBox(
          height: 20.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF99722F),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 2,
        ),
        SizedBox(
          height: 20.0,
        ),
        _buildThaiDButton(),
      ],
    );
  }

  TextStyle style = TextStyle(
    fontFamily: 'Kanit',
    fontSize: 18.0,
  );

  _buildLoginGoogle() async {
    var obj = await signInWithGoogle();
    // print('----- Login Google ----- ' + obj.toString());
    if (obj != null) {
      var model = {
        "username": obj.user?.email,
        "email": obj.user?.email,
        "imageUrl": obj.user?.photoURL != null ? obj.user?.photoURL : '',
        "firstName": obj.user?.displayName,
        "lastName": '',
        "googleID": obj.user?.uid
      };

      Dio dio = new Dio();
      var response = await dio.post(
        '${server}m/v2/register/google/login',
        data: model,
      );

      await storage.write(
        key: 'categorySocial',
        value: 'Google',
      );

      await storage.write(
        key: 'imageUrlSocial',
        value: obj.user?.photoURL != null ? obj.user?.photoURL : '',
      );

      createStorageApp(
        model: response.data['objectData'],
        category: 'google',
      );

      if (obj != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageV2(),
          ),
        );
      }
    }
  }

  _buildLoginLine() async {
    var obj = await loginLine();

    // _buildDialog(obj.toString());
    // print('----- obj -----' +
    //     obj.toString());
    final idToken = obj.accessToken.idToken;
    // _buildDialog('----- idToken -----' +
    //     idToken.toString());

    // _buildDialog(idToken.toString());
    // print('----- idToken -----' +
    //     idToken.toString());
    final userEmail = (idToken != null)
        ? idToken['email'] != null
            ? idToken['email']
            : ''
        : '';

    // _buildDialog('----- userEmail -----' +
    //     userEmail);

    // _buildDialog(
    //     '----- userProfile -----' +
    //         obj.userProfile.toString());

    if (obj != null) {
      var model = {
        "username": (userEmail != '' && userEmail != null)
            ? userEmail
            : obj.userProfile?.userId,
        "email": userEmail,
        "imageUrl": (obj.userProfile?.pictureUrl != '' &&
                obj.userProfile?.pictureUrl != null)
            ? obj.userProfile?.pictureUrl
            : '',
        "firstName": obj.userProfile?.displayName,
        "lastName": '',
        "lineID": obj.userProfile?.userId
      };

      // _buildDialog('----- model -----' +
      //     model.toString());

      Dio dio = new Dio();
      var response = await dio.post(
        '${server}m/v2/register/line/login',
        data: model,
      );

      // print(response.data['objectData']['code']);
      // storage.write(
      //   key: 'profileCode9',
      //   value: response.data['objectData']['code'],
      // );

      // storage.write(key: 'profileCategory', value: 'line');

      await storage.write(
        key: 'categorySocial',
        value: 'Line',
      );
      await storage.write(
        key: 'imageUrlSocial',
        value: (obj.userProfile?.pictureUrl != '' &&
                obj.userProfile?.pictureUrl != null)
            ? obj.userProfile?.pictureUrl
            : '',
      );

      createStorageApp(
        model: response.data['objectData'],
        category: 'line',
      );

      if (obj != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePageV2(),
          ),
        );
      }
    }
  }

  _buildLoginFacebook() async {
    await FacebookAuth.instance.logOut();
   // var obj = await signInWithFacebook();
    final LoginResult result = await FacebookAuth.instance
        .login(); // by default we request the email and the public profile
    // or FacebookAuth.i.login()
    if (result.status == LoginStatus.success) {
      // you are logged
      final AccessToken? accessToken = result.accessToken;

      if (accessToken != null) {
        // user is logged
        print(accessToken.toString());
        final userData = await FacebookAuth.i.getUserData();
        print(
            '---------------- Facebook ----------------' + userData.toString());

        try {
          var model = {
            "username":
                userData['email'].toString() ?? userData['id'].toString(),
            "email": userData['email'].toString() ?? '',
            "imageUrl": userData['picture']['data']['url'].toString(),
            "firstName": userData['name'].toString(),
            "lastName": '',
            "facebookID": userData['id'].toString()
          };

          print(
              '-------------------------- Facebook --------------------------' +
                  model.toString());

          Dio dio = new Dio();
          var response = await dio.post(
            '${server}m/v2/register/facebook/login',
            data: model,
          );

          setState(() async {
            await storage.write(
              key: 'categorySocial',
              value: 'Facebook',
            );

            await storage.write(
              key: 'imageUrlSocial',
              value: userData['picture']['data']['url'].toString() != null
                  ? userData['picture']['data']['url'].toString()
                  : '',
            );

            await createStorageApp(
              model: response.data['objectData'],
              category: 'facebook',
            );

            if (accessToken != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePageV2(),
                ),
              );
            }
          });

          // setState(() => _loadingSubmit = false);
        } catch (e) {
          // setState(() => _loadingSubmit = false);
        }
      }
    } else {
      print(result.status);
      print(result.message);
    }

    // var obj = await signInWithFacebook();
    // // print('----- Login Facebook ----- ' + obj.user.toString());
    // if (obj != null) {
    //   var model = {
    //     "username": obj.user.email,
    //     "email": obj.user.email,
    //     "imageUrl": obj.user.photoURL != null ? obj.user.photoURL : '',
    //     "firstName": obj.user.displayName,
    //     "lastName": '',
    //     "facebookID": obj.user.uid
    //   };

    //   Dio dio = new Dio();
    //   var response = await dio.post(
    //     '${server}m/v2/register/facebook/login',
    //     data: model,
    //   );

    //   await storage.write(
    //     key: 'categorySocial',
    //     value: 'Facebook',
    //   );

    //   await storage.write(
    //     key: 'imageUrlSocial',
    //     value: obj.user.photoURL != null ? obj.user.photoURL : '',
    //   );

    //   createStorageApp(
    //     model: response.data['objectData'],
    //     category: 'facebook',
    //   );

    //   if (obj != null) {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => HomePageV2(),
    //       ),
    //     );
    //   }
    // }
  }

  _buildLoginApple() async {
    var obj = await signInWithApple();

    // print('----- email ----- ${obj.credential}');
    // print(obj.credential.identityToken[4]);
    // print(obj.credential.identityToken[8]);

    var model = {
      "username": obj.user?.email != null ? obj.user?.email : obj.user?.uid,
      "email": obj.user?.email != null ? obj.user?.email : '',
      "imageUrl": '',
      "firstName": obj.user?.email,
      "lastName": '',
      "appleID": obj.user?.uid
    };

    Dio dio = new Dio();
    var response = await dio.post(
      '${server}m/v2/register/apple/login',
      data: model,
    );

    // print(
    //     '----- code ----- ${response.data['objectData']['code']}');

    createStorageApp(
      model: response.data['objectData'],
      category: 'apple',
    );

    if (obj != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePageV2(),
        ),
      );
    }
  }

  _buildLoginSocial() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (Platform.isIOS)
          new Expanded(
            flex: 1,
            child: IconButton(
              onPressed: () => _buildLoginApple(),
              icon: new Image.asset(
                "assets/apple_circle.png",
              ),
              padding: new EdgeInsets.all(5.0),
            ),
          ),
        new Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () => _buildLoginFacebook(),
            icon: new Image.asset(
              "assets/facebook_circle.png",
            ),
            padding: new EdgeInsets.all(5.0),
          ),
        ),
        new Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () => _buildLoginGoogle(),
            icon: new Image.asset(
              "assets/google_circle.png",
            ),
            padding: new EdgeInsets.all(5.0),
          ),
        ),
        new Expanded(
          flex: 1,
          child: IconButton(
            onPressed: () => _buildLoginLine(),
            icon: new Image.asset(
              "assets/line_circle.png",
            ),
            padding: new EdgeInsets.all(5.0),
          ),
        ),
      ],
    );
  }
  //
}
