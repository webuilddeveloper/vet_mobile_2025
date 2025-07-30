import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as dt_picker;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vet/loginAndRegister.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/widget/text_form_field.dart';

class RegisterPage extends StatefulWidget {
  final String username;
  final String password;
  final String facebookID;
  final String appleID;
  final String googleID;
  final String lineID;
  final String email;
  final String imageUrl;
  final String category;
  final String prefixName;
  final String firstName;
  final String lastName;
  final bool isShowStep1 = true;
  final bool isShowStep2 = false;

  RegisterPage({
    Key? key,
    required this.username,
    required this.password,
    required this.facebookID,
    required this.appleID,
    required this.googleID,
    required this.lineID,
    required this.email,
    required this.imageUrl,
    required this.category,
    required this.prefixName,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final storage = new FlutterSecureStorage();

  String? _username;
  // String _password;
  // String _facebookID;
  // String _appleID;
  // String _googleID;
  // String _lineID;
  // String _email;
  // String _imageUrl;
  // String _category;
  // String _prefixName;
  // String _firstName;
  // String _lastName;

  // bool _isLoginSocial = false;
  // bool _isLoginSocialHaveEmail = false;
  bool _isShowStep1 = true;
  bool _isShowStep2 = false;
  bool _checkedValue = false;
  // Register _register;
  List<dynamic> _dataPolicy = [];

  final _formKey = GlobalKey<FormState>();

  // List<String> _prefixNames = ['นาย', 'นาง', 'นางสาว']; // Option 2
  // String _selectedPrefixName;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtEmail = TextEditingController();
  final txtPrefixName = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  Future<dynamic>? _futureModel;

  ScrollController scrollController = new ScrollController();

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  @override
  void initState() {
    _callRead();

    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
      // _username = widget.username;
      // _password = widget.password;
      // _facebookID = widget.facebookID;
      // _appleID = widget.appleID;
      // _googleID = widget.googleID;
      // _lineID = widget.lineID;
      // _email = widget.email;
      // _imageUrl = widget.imageUrl;
      // _category = widget.category;
      // _prefixName = widget.prefixName;
      // _firstName = widget.firstName;
      // _lastName = widget.lastName;

      // txtUsername.text = widget.username;
      // futureModel = readPolicy();
    });

    // if (widget.category != 'guest') {
    //   setState(() {
    //     _isLoginSocial = true;
    //   });
    // }
    // if (widget.username != '' && widget.username != null) {
    //   setState(() {
    //     _isLoginSocialHaveEmail = true;
    //   });
    // }

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [formContentStep2()],
          );
        } else if (snapshot.hasError) {
          return Container(height: 500);
        } else {
          return Container(height: 500);
        }
      },
    );
  }

  _callRead() {
    _futureModel = postDio('${server}m/policy/read', {
      'username': this._username,
      'category': 'register',
    });
  }

  Future<dynamic> readPolicy() async {
    final result = await postObjectData('m/policy/read', {
      'username': this._username,
      'category': 'register',
    });

    if (result['status'] == 'S') {
      if (result['objectData'].length > 0) {
        setState(() {
          _dataPolicy = [..._dataPolicy, ...result['objectData']];
        });
      }
    }
  }

  Future<Null> checkValueStep1() async {
    if (_checkedValue) {
      setState(() {
        _isShowStep1 = false;
        _isShowStep2 = true;
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text(
              'กรุณาติ้ก ยอมรับข้อตกลงเงื่อนไข',
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
                    color: Color(0xFF1B6CA8),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<dynamic> submitRegister() async {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regex = RegExp(pattern);
    if (!(regex.hasMatch(txtEmail.text))) {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'รูปแบบอีเมลไม่ถูกต้อง',
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
                      color: Color(0xFF1B6CA8),
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
        },
      );
    }

    final result = await postLoginRegister('m/Register/create', {
      'username': txtUsername.text,
      'password': txtPassword.text,
      'facebookID': "",
      'appleID': "",
      'googleID': "",
      'lineID': "",
      'email': txtEmail.text,
      'imageUrl': "",
      'category': "guest",
      'prefixName': txtPrefixName.text,
      'firstName': txtFirstName.text,
      'lastName': txtLastName.text,
      'phone': txtPhone.text,
      'birthDay': "",
      // 'birthDay': DateFormat("yyyyMMdd").format(
      //   DateTime(
      //     _selectedYear,
      //     _selectedMonth,
      //     _selectedDay,
      //   ),
      // ),
      'status': "N",
      'platform': Platform.operatingSystem.toString(),
      'countUnit': "[]",
    });

    if (result.status == 'S') {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => LoginPage(),
      //   ),
      // );

      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'ลงทะเบียนเรียบร้อยแล้ว',
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
                      color: Color(0xFF1B6CA8),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    goBack();
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
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
                      color: Color(0xFF1B6CA8),
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
        },
      );
    }
  }

  dialogOpenPickerDate() {
    dt_picker.DatePicker.showDatePicker(
      context,
      theme: const dt_picker.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF1B6CA8),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(year, month, day),
      onConfirm: (date) {
        setState(() {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd-MM-yyyy").format(date),
          );
        });
      },
      currentTime: DateTime(_selectedYear, _selectedMonth, _selectedDay),
      locale: dt_picker.LocaleType.th,
    );
  }

  myWizard() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 0.0,
            left: 30.0,
            right: 30.0,
            bottom: 0.0,
          ),
          child: Column(
            children: <Widget>[
              new Row(
                children: [
                  new Column(
                    children: <Widget>[
                      new Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep1 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color:
                              _isShowStep1
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(25.0),
                          ),
                          border: new Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                      ),
                      Text(
                        'ข้อตกลง',
                        style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 2.0,
                        color: Color(0xFFFFC324),
                      ),
                    ),
                  ),
                  new Column(
                    children: <Widget>[
                      new Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          '2',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep2 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color:
                              _isShowStep2
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(25.0),
                          ),
                          border: new Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                      ),
                      Text(
                        'ข้อมูลส่วนตัว',
                        style: new TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  card() {
    return Card(
      color: Colors.white,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(15.0),
      // ),
      // elevation: 5,
      child: Padding(padding: EdgeInsets.all(0), child: formContentStep2()),
      // child: _isShowStep1 ? formContentStep1() : formContentStep2()),
    );
  }

  formContentStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var item in _dataPolicy)
          Html(
            data: item['description'],
            onLinkTap: (String? url, Map<String, String> attributes, element) {
              launch(url!);
              //open URL in webview, or launch URL in browser, or any other logic here
            },
          ),
        new Container(
          alignment: Alignment.center,
          child: CheckboxListTile(
            activeColor: Color(0xFF1B6CA8),
            title: Text(
              "ฉันยอมรับข้อตกลงในการบริการ",
              style: new TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
            value: _checkedValue,
            onChanged: (newValue) {
              setState(() {
                _checkedValue = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFFFC324),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color(0xFFFFC324)),
              ),
              textStyle: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
            onPressed: () {
              checkValueStep1();
            },
            child: Text("ถัดไป >"),
          ),
        ),
      ],
    );
  }

  formContentStep2() {
    return (Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(
          //   'ข้อมูลผู้ใช้งาน',
          //   style: TextStyle(
          //     fontSize: 18.00,
          //     fontFamily: 'Kanit',
          //     fontWeight: FontWeight.w500,
          //     // color: Color(0xFFBC0611),
          //   ),
          // ),
          // SizedBox(height: 5.0),
          // inputCus(
          //   // enabled: false,
          //   context: context,
          //   title: 'ชื่อผู้ใช้งาน',
          //   controller: txtUsername,
          //   validator: (String value) {
          //     // if (value.isEmpty) return '';
          //   },
          // ),
          Text(
            '(ชื่อผู้ใช้งานต้องใช้ตัวอักษรที่กำหนดห้ามเว้นวรรค A-Z, a-z และ 0-9 ความยาวขั้นต่ำ 4 ตัวอักษร',
            style: TextStyle(
              fontSize: 10.00,
              fontFamily: 'Kanit',
              color: Color(0xFF000000),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          // labelTextFormFieldUser('ชื่อผู้ใช้งาน', true),
          textFormFieldNew(
            txtUsername,
            '',
            'ชื่อผู้ใช้งาน',
            'ชื่อผู้ใช้งาน',
            true,
            false,
            false,
            true,
          ),
          SizedBox(height: 10),
          // labelTextFormField('* รหัสผ่าน'),
          // labelTextFormFieldPasswordOldNew('รหัสผ่าน', true),
          Text(
            '(รหัสผ่านต้องห้ามเว้นวรรค มีตัวอักษร A-Z, a-z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร',
            style: TextStyle(
              fontSize: 10.00,
              fontFamily: 'Kanit',
              color: Color(0xFF000000),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          textFormFieldNew(
            txtPassword,
            '',
            'รหัสผ่าน',
            'รหัสผ่าน',
            true,
            true,
            false,
            false,
          ),
          SizedBox(height: 10),
          // labelTextFormFieldRequired('* ', 'ยืนยันรหัสผ่าน'),
          _textConPassword(),
          // textFormField(
          //   txtConPassword,
          //   txtPassword.text,
          //   'ยืนยันรหัสผ่าน',
          //   'ยืนยันรหัสผ่าน',
          //   true,
          //   true,
          //   false,
          // ),
          // SizedBox(height: 15.0),
          // Text(
          //   'ข้อมูลส่วนตัว',
          //   style: TextStyle(
          //     fontSize: 18.00,
          //     fontFamily: 'Kanit',
          //     fontWeight: FontWeight.w500,
          //     // color: Color(0xFFBC0611),
          //   ),
          // ),
          SizedBox(height: 10),
          // labelTextFormFieldRequired('* ', 'อีเมล'),
          textFormFieldNew(
            txtEmail,
            '',
            'อีเมล',
            'อีเมล',
            true,
            false,
            true,
            false,
          ),
          SizedBox(height: 10),
          // labelTextFormField('คำนำหน้า'),
          // textFormField(
          //   txtPrefixName,
          //   '',
          //   'คำนำหน้า',
          //   'คำนำหน้า',
          //   true,
          //   false,
          //   false,
          // ),
          // new Container(
          //   width: 5000.0,
          //   padding: EdgeInsets.symmetric(
          //     horizontal: 5,
          //     vertical: 0,
          //   ),
          //   decoration: BoxDecoration(
          //     color: Color(0xFFC5DAFC),
          //     borderRadius: BorderRadius.circular(
          //       10,
          //     ),
          //   ),
          //   // child: DropdownButtonHideUnderline(
          //   child: DropdownButtonFormField(
          //     decoration: InputDecoration(
          //       errorStyle: TextStyle(
          //         fontWeight: FontWeight.normal,
          //         fontFamily: 'Kanit',
          //         fontSize: 10.0,
          //       ),
          //       enabledBorder: UnderlineInputBorder(
          //         borderSide: BorderSide(
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //     validator: (value) =>
          //         value == '' || value == null ? 'กรุณาเลือกคำนำหน้า' : null,
          //     hint: Text(
          //       'กรุณาเลือกคำนำหน้า',
          //       style: TextStyle(
          //         fontSize: 15.00,
          //         fontFamily: 'Kanit',
          //       ),
          //     ),
          //     value: _selectedPrefixName,
          //     onChanged: (newValue) {
          //       setState(() {
          //         _selectedPrefixName = newValue;
          //       });
          //     },
          //     items: _prefixNames.map((prefixName) {
          //       return DropdownMenuItem(
          //         child: new Text(
          //           prefixName,
          //           style: TextStyle(
          //             fontSize: 15.00,
          //             fontFamily: 'Kanit',
          //             color: Color(
          //               0xFF1B6CA8,
          //             ),
          //           ),
          //         ),
          //         value: prefixName,
          //       );
          //     }).toList(),
          //   ),
          //   // ),
          // ),
          // labelTextFormFieldRequired('* ', 'ชื่อ'),
          textFormFieldNew(
            txtFirstName,
            '',
            'ชื่อ',
            'ชื่อ',
            true,
            false,
            false,
            false,
          ),
          SizedBox(height: 10),
          // labelTextFormFieldRequired('* ', 'นามสกุล'),
          textFormFieldNew(
            txtLastName,
            '',
            'นามสกุล',
            'นามสกุล',
            true,
            false,
            false,
            false,
          ),
          SizedBox(height: 10),
          // labelTextFormField('วันเดือนปีเกิด'),
          // GestureDetector(
          //   onTap: () => dialogOpenPickerDate(),
          //   child: AbsorbPointer(
          //     child: TextFormField(
          //       controller: txtDate,
          //       style: TextStyle(
          //         color: Color(0xFF1B6CA8),
          //         fontWeight: FontWeight.normal,
          //         fontFamily: 'Kanit',
          //         fontSize: 15.0,
          //       ),
          //       decoration: InputDecoration(
          //         filled: true,
          //         fillColor: Color(0xFFC5DAFC),
          //         contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          //         hintText: "วันเดือนปีเกิด",
          //         border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10.0),
          //           borderSide: BorderSide.none,
          //         ),
          //         errorStyle: TextStyle(
          //           fontWeight: FontWeight.normal,
          //           fontFamily: 'Kanit',
          //           fontSize: 10.0,
          //         ),
          //       ),
          //       // validator: (model) {
          //       //   if (model.isEmpty) {
          //       //     return 'กรุณากรอกวันเดือนปีเกิด.';
          //       //   }
          //       // },
          //     ),
          //   ),
          // ),
          // labelTextFormField('* เบอร์โทรศัพท์ (10 หลัก)'),
          // textFormPhoneField(
          //   txtPhone,
          //   'เบอร์โทรศัพท์ (10 หลัก)',
          //   'เบอร์โทรศัพท์ (10 หลัก)',
          //   true,
          //   true,
          // ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(5.0),
                color: Color(0xFF99722F),
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  height: 40,
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      submitRegister();
                    }
                  },
                  child: new Text(
                    'สมัครสมาชิก',
                    style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  _textConPassword() {
    return TextFormField(
      obscureText: true,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      style: TextStyle(
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.00,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 15),
        labelText: 'ยืนยันรหัสผ่าน',
        labelStyle: TextStyle(
          color: Color(0xFF7090AC),
          fontWeight: FontWeight.w300,
          fontFamily: 'Kanit',
          fontSize: 15.00,
        ),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(5.0),
        //   borderSide: BorderSide(width: 1, color: Color(0xFFD77E23)),
        // ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1, color: Color(0xFF7090AC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1, color: Color(0xFFB6B6B6)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(width: 1, color: Color(0xFFFF0000)),
        ),
      ),
      // decoration: InputDecoration(
      //   hintText: 'ยืนยันรหัสผ่าน',
      //   filled: true,
      //   fillColor: Color(0xFFC5DAFC),
      //   contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(10.0),
      //     borderSide: BorderSide.none,
      //   ),
      //   errorStyle: TextStyle(
      //     fontWeight: FontWeight.normal,
      //     fontFamily: 'Kanit',
      //     fontSize: 10.0,
      //   ),
      // ),
      validator: (model) {
        if (model!.isEmpty) {
          return 'กรุณากรอกข้อมูล. $model';
        }

        if (model != txtPassword.text) return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
      },
      controller: txtConPassword,
      enabled: true,
    );
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginAndRegisterPage()),
      (Route<dynamic> route) => false,
    );
  }
}
