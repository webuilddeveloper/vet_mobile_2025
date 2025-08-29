// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'dart:io' show Platform;

import 'package:url_launcher/url_launcher.dart';
import 'package:vet/component/header_v2.dart';
import 'package:vet/home_v2.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/widget/dialog.dart';
import 'package:vet/widget/text_form_field.dart';

class EnfranchiseMain extends StatefulWidget {
  EnfranchiseMain({Key? key, this.reference}) : super(key: key);
  final String? reference;
  @override
  _EnfranchiseMain createState() => _EnfranchiseMain();
}

class _EnfranchiseMain extends State<EnfranchiseMain> {
  final storage = FlutterSecureStorage();
  bool isConfirm = false;
  int currentStep = 0;
  String profileCode = "";
  String ref_code = "";
  String updateDate = "";
  String expDate = "";
  String linkUrl =
      "https://deeplink.doctoratoz.co/?m=prod&a=daz&c=opeconmobile";
  late Future<dynamic> _futureEnfrancise;
  late Future<dynamic> _futureProfile;
  late Future<dynamic> _futureOTPSend;
  late Future<dynamic> _futureOTPValidate;
  late Future<dynamic> _futureChkEnfrancise;
  dynamic _enfrancise;
  dynamic _profile;
  dynamic _otp;
  dynamic _chkenfrancise;
  String selectedType = '1';
  var focusNode = FocusNode();
  var focusNode2 = FocusNode();
  var focusNode3 = FocusNode();
  var focusNode4 = FocusNode();
  var focusNode5 = FocusNode();
  var focusNode6 = FocusNode();

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context, false);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => HomePageV2(),
    //   ),
    // );
  }

  _callRead() async {
    profileCode = (await storage.read(key: 'profileCode10'))!;
    _futureEnfrancise = postDio('${server}m/enfranchise/read', {
      'code': profileCode,
      'reference': widget.reference,
    });
    _enfrancise = await _futureEnfrancise;
    _futureProfile = postDio(profileReadApi, {'code': profileCode});
    _profile = await _futureProfile;
    if (_enfrancise.length > 0) {
      isConfirm = true;
      currentStep = getSteps().length - 1;
      setState(() {
        txtFirstName.text = (_enfrancise[0]['firstName'] ?? '');
        txtLastName.text = (_enfrancise[0]['lastName'] ?? '');
        txtPhone.text = (_enfrancise[0]['phone'] ?? '');
        txtEmail.text = (_enfrancise[0]['email'] ?? '');
        _selectedAgeRange = (_enfrancise[0]['ageRange'] ?? '');
        txtJob.text = (_enfrancise[0]['job'] ?? '');
        _selectedProvince = (_enfrancise[0]['provinceCode'] ?? '');
        _selectedProvinceName = (_enfrancise[0]['province'] ?? '');
        ref_code = (_enfrancise[0]['ref_code'] ?? '');
        updateDate = (_enfrancise[0]['updateDate'] ?? '');
        expDate = (_enfrancise[0]['expDate'] ?? '');
        linkUrl = (_enfrancise[0]['linkUrl'] ?? '');
      });
    } else {
      setState(() {
        txtFirstName.text = (_profile['firstName'] ?? '');
        txtLastName.text = (_profile['lastName'] ?? '');
        txtPhone.text = (_profile['phone'] ?? '');
        txtEmail.text = (_profile['email'] ?? '');
      });
    }
    getProvince();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(context, goBack, title: 'รับสิทธิ์'),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            //onStepTapped: (step) => setState(() => currentStep = step),
            onStepContinue: () async {
              final isLastStep = currentStep == getSteps().length - 1;
              if (isLastStep) {
                setState(() {
                  isConfirm = true;
                });
                // print('-------- isLastStep -----');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePageV2()),
                );
              } else {
                var ischk = false;
                if (currentStep == 0) {
                  ischk = await chkStep1();
                  if (ischk) focusNode.requestFocus();
                }
                if (currentStep == 1) {
                  ischk = await chkStep2();
                  if (ischk) focusNode6.unfocus();
                }
                if (ischk)
                  setState(() {
                    currentStep += 1;
                  });
              }
            },
            onStepCancel:
                currentStep == 0
                    ? null
                    : () => setState(() {
                      currentStep -= 1;
                    }),
            steps: getSteps(),
            controlsBuilder: (context, ControlsDetails detail) {
              final isLastStep = currentStep == getSteps().length - 1;
              return Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    if (currentStep != 0 && !isLastStep)
                      Expanded(
                        child: ElevatedButton(
                          child: Text("Back"),
                          onPressed: detail.onStepCancel,
                        ),
                      ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xFF99722F),
                          ),
                        ),
                        child: Text(isLastStep ? "เสร็จสิ้น" : "ถัดไป"),
                        onPressed: detail.onStepContinue,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  chkStep1() async {
    var isJob = true;
    if (_selectedJob != "")
      if (_selectedJob == "other") {
        if (txtJob.text != "") isJob = false;
      } else {
        isJob = false;
      }

    if ((txtFirstName.text == "") ||
        (txtLastName.text == "") ||
        (txtPhone.text == "") ||
        (txtEmail.text == "") ||
        // (_selectedJob == "" && txtJob.text == "") ||
        isJob ||
        (_selectedAgeRange == "") ||
        (_selectedProvince == "")) {
      dialog(
        context,
        title: 'ทำรายการไม่สำเสร็จ',
        description: 'กรุณากรอกข้อมูลให้ถูกต้องและครบถ้วน',
      );
      return false;
    } else {
      if (txtPhone.text.replaceAll('-', '').trim().length != 10) {
        dialog(
          context,
          title: 'เบอร์โทรศัพท์',
          description: 'กรุณาใส่เบอร์โทรให้ถูกต้อง',
        );
        return false;
      }
      if (txtPhone.text.replaceAll('-', '').trim().length == 10) {
        _futureChkEnfrancise = postDio('${server}m/enfranchise/read', {
          'phone': txtPhone.text.replaceAll('-', '').trim(),
        });
        _chkenfrancise = await _futureChkEnfrancise;
        if (_chkenfrancise.length > 0) {
          dialog(
            context,
            title: 'เบอร์โทรศัพท์',
            description: 'มีเบอร์โทรนี้อยู่ในระบบแล้ว ไม่สามารถรับสิทธิ์ได้',
          );
          return false;
        } else {
          var data = {
            "profileCode": profileCode,
            "reference": widget.reference,
            "firstName": txtFirstName.text,
            "lastName": txtLastName.text,
            "phone": txtPhone.text,
            "email": txtEmail.text,
            "ageRange": _selectedAgeRange,
            "job":
                (_selectedJob != ""
                    ? _selectedJob == "other"
                        ? txtJob.text
                        : _selectedJob
                    : _selectedJob),
            "provinceCode": _selectedProvince,
            "province": _selectedProvinceName,
            "updateBy": _profile['username'],
          };
          postDio(server + 'm/enfranchise/create', data);
          _futureOTPSend = postOTPSend('otp-send', {
            "project_key": "XcvVbGHhAi",
            "phone": txtPhone.text.replaceAll('-', '').trim(),
            "ref_code": "xxx123",
          });
          _otp = await _futureOTPSend;
          return true;
        }
      } else {
        var data = {
          "profileCode": profileCode,
          "reference": widget.reference,
          "firstName": txtFirstName.text,
          "lastName": txtLastName.text,
          "phone": txtPhone.text,
          "email": txtEmail.text,
          "ageRange": _selectedAgeRange,
          "job": txtJob.text,
          "provinceCode": _selectedProvince,
          "province": _selectedProvinceName,
          "updateBy": _profile['username'],
        };
        postDio(server + 'm/enfranchise/create', data);
        _futureOTPSend = postOTPSend('otp-send', {
          "project_key": "XcvVbGHhAi",
          "phone": txtPhone.text.replaceAll('-', '').trim(),
          "ref_code": "xxx123",
        });
        _otp = await _futureOTPSend;
        return true;
      }
    }
  }

  chkStep2() async {
    _futureOTPValidate = postOTPSend('otp-validate', {
      "token": _otp['token'],
      "otp_code":
          '${txtnumber1.text}${txtnumber2.text}${txtnumber3.text}${txtnumber4.text}${txtnumber5.text}${txtnumber6.text}',
      "ref_code": _otp['ref_code'],
    });
    var validate = await _futureOTPValidate;
    if (validate['status']) {
      var data = {
        "profileCode": profileCode,
        "reference": widget.reference,
        "firstName": txtFirstName.text,
        "lastName": txtLastName.text,
        "phone": txtPhone.text,
        "email": txtEmail.text,
      };
      ref_code = await postDio(server + 'm/enfranchise/updateStatus', data);
      _callRead();
      // _futureEnfrancise = postDio('${server}m/enfranchise/read', {
      //   'code': profileCode,
      //   'reference': widget.reference,
      // });
      // _enfrancise = await _futureEnfrancise;
      // setState(() {
      //   updateDate = (_enfrancise[0]['updateDate'] ?? '');
      // });
      return true;
    } else {
      dialog(
        context,
        title: 'OTP ไม่ถูกต้อง',
        description: 'กรุณากรอกรหัส OTP ให้ถูกต้องหรือข้อรหัสใหม่',
      );
      return false;
    }
  }

  List<Step> getSteps() => [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 0,
      title: Text("ลงทะเบียน"),
      content: _contentStep1(),
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: Text("OTP"),
      content: _contentStep2(),
    ),
    Step(
      state: currentStep > 2 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 2,
      title: Text("เสร็จสิ้น"),
      content: _contentStep3(),
    ),
  ];

  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  final txtEmail = TextEditingController();
  final txtJob = TextEditingController();
  List<dynamic> _itemJob = [
    {'code': 'ครู อาจารย์', 'title': 'ครู อาจารย์'},
    {'code': 'ผู้บริหารโรงเรียน', 'title': 'ผู้บริหารโรงเรียน'},
    {'code': 'เจ้าของโรงเรียน', 'title': 'เจ้าของโรงเรียน'},
    {'code': 'นักเรียน นักศึกษา', 'title': 'นักเรียน นักศึกษา'},
    {'code': 'ข้าราชการ รัฐวิสาหกิจ', 'title': 'ข้าราชการ รัฐวิสาหกิจ'},
    {'code': 'พนักงานบริษัทเอกชน', 'title': 'พนักงานบริษัทเอกชน'},
    {'code': 'เจ้าของกิจการ', 'title': 'เจ้าของกิจการ'},
    {'code': 'รับจ้าง', 'title': 'รับจ้าง'},
    {'code': 'อาชีพอิสระ', 'title': 'อาชีพอิสระ'},
    {'code': 'other', 'title': 'อื่นๆ'},
  ];
  String _selectedJob = "";
  List<dynamic> _itemAgeRange = [
    {'code': '20-30', 'title': '20-30'},
    {'code': '31-40', 'title': '31-40'},
    {'code': '41-50', 'title': '41-50'},
    {'code': '51-60', 'title': '51-60'},
    {'code': '>60', 'title': '>60'},
  ];
  late String _selectedAgeRange;
  List<dynamic> _itemProvince = [];
  late String _selectedProvince;
  late String _selectedProvinceName;
  Future<dynamic> getProvince() async {
    final result = await postObjectData("route/province/read", {});
    if (result['status'] == 'S') {
      setState(() {
        _itemProvince = result['objectData'];
      });
    }
  }

  _contentStep1() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ข้อดีของการปรึกษาออนไลน์',
            style: TextStyle(
              fontSize: 17.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              // color: Color(0xFFBC0611),
            ),
          ),
          Text(
            '- ลดเวลา',
            style: TextStyle(
              fontSize: 13.00,
              fontFamily: 'Kanit',
              // fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
            ),
          ),
          Text(
            '- ลดค่าใช้จ่าย',
            style: TextStyle(
              fontSize: 13.00,
              fontFamily: 'Kanit',
              // fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
            ),
          ),
          Text(
            '- ลดการสูญเสีย',
            style: TextStyle(
              fontSize: 13.00,
              fontFamily: 'Kanit',
              // fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
            ),
          ),
          Text(
            'ลงทะเบียน',
            style: TextStyle(
              fontSize: 17.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              // color: Color(0xFFBC0611),
            ),
          ),
          Text(
            'ท่านสามารถเริ่มทดลองปรึกษาหมอออนไลน์ได้จากการทำตามขั้นตอนง่ายๆดังต่อไปนี้',
            style: TextStyle(
              fontSize: 13.00,
              fontFamily: 'Kanit',
              // fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
            ),
          ),
          InkWell(
            onTap: () {
              launch(
                'https://policy.we-builds.com/thaire/opec_Privacy%20Policy%20for%20Individual%2021092021.pdf',
              );
            },
            child: Text(
              'นโยบาย',
              style: TextStyle(
                fontSize: 17.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                // color: Color(0xFFBC0611),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              launch(
                'https://policy.we-builds.com/thaire/opec_Privacy%20Policy%20for%20Individual%2021092021.pdf',
              );
            },
            child: Text(
              'นโยบายการให้บริการและการคุ้มครองข้อมูลส่วนบุคคล',
              style: TextStyle(
                fontSize: 13.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFF707070),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              launch(
                'https://policy.we-builds.com/thaire/opec_Privacy%20Policy%20for%20Individual%2021092021.pdf',
              );
            },
            child: Text(
              'คลิกดูรายละเอียดเพิ่มเติม',
              style: TextStyle(
                fontSize: 13.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFF0000FF),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          labelTextFormFieldRequired('* ', 'ชื่อ'),
          textFormFieldEdit(
            txtFirstName,
            '',
            'ชื่อ',
            'ชื่อ',
            true,
            false,
            false,
            false,
          ),
          labelTextFormFieldRequired('* ', 'นามสกุล'),
          textFormFieldEdit(
            txtLastName,
            '',
            'นามสกุล',
            'นามสกุล',
            true,
            false,
            false,
            false,
          ),
          // labelTextFormField('เบอร์โทรศัพท์', mandatory: true),
          labelTextFormFieldRequired('* ', 'เบอร์โทรศัพท์ (10 หลัก)'),
          textFormPhoneFieldEdit(
            txtPhone,
            'เบอร์โทรศัพท์ (10 หลัก)',
            'เบอร์โทรศัพท์ (10 หลัก)',
            true,
            false,
          ),
          labelTextFormFieldRequired('* ', 'Email'),
          textFormFieldEdit(
            txtEmail,
            '',
            'Email',
            'Email',
            true,
            false,
            false,
            false,
          ),
          labelTextFormFieldRequired('* ', 'ช่วงอายุ'),
          Container(
            width: 5000.0,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            // decoration: BoxDecoration(
            //   color: Color(0xFFC5DAFC),
            //   borderRadius: BorderRadius.circular(
            //     10,
            //   ),
            // ),
            child:
                (_selectedAgeRange != '')
                    ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      validator:
                          (value) =>
                              value == '' || value == null
                                  ? 'กรุณาเลือกช่วงอายุ'
                                  : null,
                      value: _selectedAgeRange,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        TextEditingController().clear();
                      },
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAgeRange = newValue?.toString() ?? '';
                        });
                      },
                      items:
                          _itemAgeRange.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF1B6CA8),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                    )
                    : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      validator:
                          (value) =>
                              value == '' || value == null
                                  ? 'กรุณาเลือกช่วงอายุ'
                                  : null,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAgeRange = newValue?.toString() ?? '';
                        });
                      },
                      items:
                          _itemAgeRange.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF1B6CA8),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                    ),
          ),
          labelTextFormFieldRequired('* ', 'อาชีพ'),
          Container(
            width: 5000.0,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            // decoration: BoxDecoration(
            //   color: Color(0xFFC5DAFC),
            //   borderRadius: BorderRadius.circular(
            //     10,
            //   ),
            // ),
            child:
                (_selectedJob != '')
                    ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      validator:
                          (value) =>
                              value == '' || value == null
                                  ? 'กรุณาเลือกอาชีพ'
                                  : null,
                      value: _selectedJob,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        TextEditingController().clear();
                      },
                      onChanged: (newValue) {
                        setState(() {
                          _selectedJob = newValue?.toString() ?? '';
                        });
                      },
                      items:
                          _itemJob.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF1B6CA8),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                    )
                    : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      validator:
                          (value) =>
                              value == '' || value == null
                                  ? 'กรุณาเลือกอาชีพ'
                                  : null,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedJob = newValue?.toString() ?? '';
                        });
                      },
                      items:
                          _itemJob.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF1B6CA8),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                    ),
          ),

          _selectedJob == "other"
              ? labelTextFormFieldRequired('* ', 'กรุณาระบุอาชีพ')
              : Container(),
          _selectedJob == "other"
              ? textFormFieldEdit(
                txtJob,
                '',
                'อาชีพ',
                'อาชีพ',
                true,
                false,
                false,
                false,
              )
              : Container(),
          labelTextFormFieldRequired('* ', 'จังหวัด'),
          Container(
            width: 5000.0,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            // decoration: BoxDecoration(
            //   color: Color(0xFFC5DAFC),
            //   borderRadius: BorderRadius.circular(
            //     10,
            //   ),
            // ),
            child:
                (_selectedProvince != '')
                    ? DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      validator:
                          (value) =>
                              value == '' || value == null
                                  ? 'กรุณาเลือกจังหวัด'
                                  : null,
                      value: _selectedProvince,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        TextEditingController().clear();
                      },
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProvince = newValue?.toString() ?? '';
                          _selectedProvinceName =
                              _itemProvince.firstWhere(
                                (i) => i['code'] == _selectedProvince,
                              )['title'];
                        });
                      },
                      items:
                          _itemProvince.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF1B6CA8),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                    )
                    : DropdownButtonFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                          fontSize: 10.0,
                        ),
                        // enabledBorder: UnderlineInputBorder(
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // ),
                      ),
                      validator:
                          (value) =>
                              value == '' || value == null
                                  ? 'กรุณาเลือกจังหวัด'
                                  : null,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProvince = newValue?.toString() ?? '';
                          _selectedProvinceName =
                              _itemProvince.firstWhere(
                                (i) => i['code'] == _selectedProvince,
                              )['title'];
                        });
                      },
                      items:
                          _itemProvince.map((item) {
                            return DropdownMenuItem(
                              child: Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 15.00,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF1B6CA8),
                                ),
                              ),
                              value: item['code'],
                            );
                          }).toList(),
                    ),
          ),
        ],
      ),
    );
  }

  final txtnumber1 = TextEditingController();
  final txtnumber2 = TextEditingController();
  final txtnumber3 = TextEditingController();
  final txtnumber4 = TextEditingController();
  final txtnumber5 = TextEditingController();
  final txtnumber6 = TextEditingController();
  _confirm2() async {
    _futureOTPSend = postOTPSend('otp-send', {
      "project_key": "XcvVbGHhAi",
      "phone": txtPhone.text.replaceAll('-', '').trim(),
      "ref_code": "xxx123",
    });
    _otp = await _futureOTPSend;
  }

  _contentStep2() {
    return Column(
      children: [
        Text(
          'Verification',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          "Enter your OTP code number",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black38,
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _textFieldOTP(
              txtnumber1,
              first: true,
              last: false,
              focusNode: focusNode,
            ),
            _textFieldOTP(
              txtnumber2,
              first: false,
              last: false,
              focusNode: focusNode2,
            ),
            _textFieldOTP(
              txtnumber3,
              first: false,
              last: false,
              focusNode: focusNode3,
            ),
            _textFieldOTP(
              txtnumber4,
              first: false,
              last: false,
              focusNode: focusNode4,
            ),
            _textFieldOTP(
              txtnumber5,
              first: false,
              last: false,
              focusNode: focusNode5,
            ),
            _textFieldOTP(
              txtnumber6,
              first: false,
              last: true,
              focusNode: focusNode6,
            ),
          ],
        ),
        SizedBox(height: 22),
        SizedBox(
          width: double.infinity * 100,
          child: ElevatedButton(
            onPressed: () {
              _confirm2();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('ขอ OTP อีกครั้ง', style: TextStyle(fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _textFieldOTP(model, {bool? first, last, FocusNode? focusNode}) {
    return SizedBox(
      height: (MediaQuery.of(context).size.height / 100) * 10,
      width: (MediaQuery.of(context).size.width / 100) * 13,
      child: AspectRatio(
        aspectRatio: 0.95,
        child: TextField(
          focusNode: focusNode,
          autofocus: currentStep == 1 ? true : false,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Colors.black12),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xFF1B6CA8)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          controller: model,
        ),
      ),
    );
  }

  _contentStep3Old() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ผลการลงทะเบียน',
          style: TextStyle(
            fontSize: 20.00,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.w500,
            // color: Color(0xFFBC0611),
          ),
        ),
        SizedBox(height: 20, child: Divider(thickness: 3)),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "ชื่อ - นามสกุล",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '   ${txtFirstName.text} ${txtLastName.text}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "เบอร์โทรศัพท์",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '   ${txtPhone.text}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "อีเมล",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '   ${txtEmail.text}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "ช่วงอายุ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '   $_selectedAgeRange',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "อาชีพ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '   ${txtJob.text}',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "จังหวัด",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '   $_selectedProvinceName',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "วันที่รับสิทธิ์",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                (updateDate ?? '').toString() != ''
                    ? "   ${DateFormat("dd-MM-yyyy").format(DateTime.parse(updateDate.substring(0, 8)))}"
                    : '',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "วันที่หมดอายุ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                expDate,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        // SizedBox(
        //   height: 10.0,
        // ),
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              width: 100,
              child: Text(
                "Code",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  '   $ref_code',
                  style: TextStyle(
                    fontSize: 15.00,
                    fontFamily: 'Kanit',
                    // fontWeight: FontWeight.w500,
                    // color: Color(0xFFBC0611),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: Text('คัดลอก'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: ref_code));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Center(
          child: InkWell(
            onTap: () {
              launch(linkUrl);
            },
            child: Container(
              alignment: Alignment.center,
              width: (MediaQuery.of(context).size.width / 100) * 50,
              height: (MediaQuery.of(context).size.height / 100) * 7,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0XFF32CD32),
              ),
              child: Text(
                "ใช้ Code",
                style: TextStyle(
                  fontSize: 16.00,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w500,
                  // color: Colors.white
                  // color: Color(0xFFBC0611),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: Text(
            'ปรึกษาอาการโควิด-19',
            style: TextStyle(
              fontSize: 18.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              // color: Color(0xFFBC0611),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Center(
          child: SizedBox(
            width: 170,
            height: 150,
            child: Image.asset(
              'assets/images/qr-code_atoz.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
          child: InkWell(
            onTap: () {
              if (Platform.isAndroid) {
                launch(
                  'https://play.google.com/store/apps/details?id=co.doctoratoz.app&hl=th&gl=US',
                );
              } else if (Platform.isIOS) {
                launch(
                  'https://apps.apple.com/th/app/doctor-a-to-z/id1484302837',
                );
              }
            },
            child: SizedBox(
              width: 170,
              height: 150,
              child: Image.asset(
                'assets/images/ios_android.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _contentStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            'การจองเสร็จสมบูรณ์',
            style: TextStyle(
              fontSize: 20.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFF408C40),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            'ขอบคุณที่เลือกปรึกษาหมอกับเรา',
            style: TextStyle(
              fontSize: 13.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
            ),
          ),
        ),
        SizedBox(height: 10),
        TicketWidget(
          width: 350,
          height: 500,
          isCornerRounded: true, // มุมโค้ง
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              InkWell(
                onTap: () async {
                  final url =
                      Platform.isAndroid
                          ? 'https://play.google.com/store/apps/details?id=co.doctoratoz.app&hl=th&gl=US'
                          : 'https://apps.apple.com/th/app/doctor-a-to-z/id1484302837';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(10),
                  child: Image.asset('assets/images/doctor.png', height: 150),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ใช้สิทธิ์ได้ถึง",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    expDate,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Kanit',
                      color: Color(0xFF9A1120),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        TicketWidget(
          width: 350,
          height: 500,
          isCornerRounded: true, // มุมโค้ง
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                width: (MediaQuery.of(context).size.width / 100) * 65,
                height: 30,
                decoration: BoxDecoration(
                  color: Color(0XFFEEBA34),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedType = '1';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color:
                                selectedType == '1'
                                    ? Color(0XFFEEBA34)
                                    : Color(0XFFF3E4E6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'โค้ด',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:
                                  selectedType == '1'
                                      ? Color(0XFF981424)
                                      : Color(0XFF707070),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
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
                            color:
                                selectedType == '2'
                                    ? Color(0XFFEEBA34)
                                    : Color(0XFFF3E4E6),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'รายละเอียด',
                            style: TextStyle(
                              fontFamily: 'Kanit',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color:
                                  selectedType == '2'
                                      ? Color(0XFF981424)
                                      : Color(0XFF707070),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              selectedType == "1"
                  ? SizedBox(
                    height: (MediaQuery.of(context).size.height / 100) * 33,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30, bottom: 40),
                          alignment: Alignment.center,
                          child: Text(
                            '$ref_code',
                            style: TextStyle(
                              fontSize: 35.00,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                              // color: Color(0xFFBC0611),
                            ),
                          ),
                        ),
                        Center(
                          child: InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(text: ref_code),
                              );
                              // launch(linkUrl);
                              launch(linkUrl);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  30,
                              height:
                                  (MediaQuery.of(context).size.height / 100) *
                                  5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFF1B6CA8),
                              ),
                              child: Text(
                                "ใช้รหัส",
                                style: TextStyle(
                                  fontSize: 16.00,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  : SizedBox(
                    height: (MediaQuery.of(context).size.height / 100) * 33,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 100) *
                                    12,
                              ),
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  37,
                              child: Text(
                                "ชื่อ - นามสกุล",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '   ${txtFirstName.text} ${txtLastName.text}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 100) *
                                    12,
                              ),
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  37,
                              child: Text(
                                "เบอร์โทรศัพท์",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '   ${txtPhone.text}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 100) *
                                    12,
                              ),
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  37,
                              child: Text(
                                "อีเมล",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '   ${txtEmail.text}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 100) *
                                    12,
                              ),
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  37,
                              child: Text(
                                "ช่วงอายุ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '   $_selectedAgeRange',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 100) *
                                    12,
                              ),
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  37,
                              child: Text(
                                "อาชีพ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '   ${txtJob.text}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 100) *
                                    12,
                              ),
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  37,
                              child: Text(
                                "จังหวัด",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '   $_selectedProvinceName',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 100) *
                                    12,
                              ),
                              width:
                                  (MediaQuery.of(context).size.width / 100) *
                                  37,
                              child: Text(
                                "วันที่รับสิทธิ์",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Kanit',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              (updateDate).toString() != ''
                                  ? "   ${DateFormat("dd-MM-yyyy").format(DateTime.parse(updateDate.substring(0, 8)))}"
                                  : '',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Kanit',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
            ],
          ),
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () {
            // launch('https://www.youtube.com/watch?v=yhrxbrhALMQ&t=195s');
            launch('https://www.youtube.com/watch?v=yhrxbrhALMQ&t=195s');
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Text(
              'ขั้นตอนการใช้งาน Doctor A to Z',
              style: TextStyle(
                fontSize: 15.00,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w500,
                color: Color(0xFF0000FF),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.centerLeft,
          child: Text(
            'บริการช่วยเหลือติดต่อ',
            style: TextStyle(
              fontSize: 13.00,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFF707070),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            // await launch("https://line.me/ti/p/~@doctoratoz");
            launch("https://line.me/ti/p/~@doctoratoz");
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  '1. Line : ',
                  style: TextStyle(
                    fontSize: 13.00,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
                Text(
                  '@doctoratoz',
                  style: TextStyle(
                    fontSize: 13.00,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0000FF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () {
            launch('tel:02 080 3911');
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  '2. Tel : ',
                  style: TextStyle(
                    fontSize: 13.00,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF707070),
                  ),
                ),
                Text(
                  '02 080 3911',
                  style: TextStyle(
                    fontSize: 13.00,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0000FF),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
