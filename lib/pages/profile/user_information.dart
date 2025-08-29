import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vet/pages/blank_page/dialog_fail.dart';
import 'package:vet/pages/check_credits/check_credits_list.dart';
import 'package:vet/pages/profile/change_password.dart';
import 'package:vet/pages/profile/edit_user_information.dart';
import 'package:vet/pages/profile/identity_verification.dart';
import 'package:vet/pages/profile/setting_notification.dart';
import 'package:vet/policy.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/widget/dialog.dart';

class UserInformationPage extends StatefulWidget {
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final storage = new FlutterSecureStorage();
  Future<dynamic>? _futureProfile;
  // Future<dynamic>? _futureCredits;
  DateTime? currentBackPressTime;
  String categorySocial = '';
  String _idcard = '';
  String _licenseNumber = '';
  String? licenseNumberSub;
  double sum = 0;
  dynamic userData;
  bool showCredits = true;

  @override
  void initState() {
    _read();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
        backgroundColor: Color(0xFFF0F4F6),
        body: FutureBuilder<dynamic>(
          future: _futureProfile,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData)
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white70,
                            ),
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 40,
                            ),
                            child:
                                snapshot.data['imageUrl'] != null &&
                                        snapshot.data['imageUrl'] != ''
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.network(
                                        snapshot.data['imageUrl'],
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                    : Container(
                                      padding: EdgeInsets.all(10),
                                      child: Image.asset(
                                        'assets/images/user_not_found.png',
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                      ),
                                    ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 20,
                          child: GestureDetector(
                            onTap: () => goBack(),
                            child: Image.asset(
                              "assets/logo/icons/backLeft.png",
                              height: 40, // Your Height
                              width: 40, // Your width
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Text(
                          '${userData['firstName']} ${userData['lastName']}',
                          style: new TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ),
                    if (userData['licenseNumber'] != null &&
                        userData['licenseNumber'] != '')
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Center(
                          child: Text(
                            '${userData['licenseNumber']}',
                            style: new TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //   if(userData['licenseNumber'] != null &&
                              // userData['licenseNumber'] != '')
                              columnYourCredits(),
                              SizedBox(width: 25),
                              columnEditInformation(),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'ตั้งค่าผู้ใช้',
                            style: new TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildContentCard(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    buttonLogout(),
                    SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(right: 5),
                      child: Text(
                        // '3.0.3+3',
                        versionName,
                        style: new TextStyle(
                          // fontSize: 9.0,
                          color: Color(0xFF1B6CA8),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            else
              return buttonLogout();
          },
        ),
      ),
    );
  }

  _read() async {
    //read profile
    var profileCode = await storage.read(key: 'profileCode10');

    categorySocial = await storage.read(key: 'categorySocial') ?? '';

    if (categorySocial == '' || categorySocial == null)
      setState(() {
        categorySocial = '';
      });

    if (profileCode != '' && profileCode != null)
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
      });

    var data = await _futureProfile;

    setState(() {
      userData = data;
    });

    _idcard = userData["idcard"];
    _licenseNumber = userData["licenseNumber"];
    if (_licenseNumber != "" && _licenseNumber != null) {
      licenseNumberSub = _licenseNumber.substring(8);
    }

    Dio dio = new Dio();
    var response = await dio.post(
      'https://gateway.we-builds.com/py-api/vet/member/credit/',
      data: {"id_card": _idcard, "isRoundCredit": true},
    );

    setState(() {
      sum = response.data['credit'];
      showCredits = false;
    });
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  _buildContentCard() {
    return Column(
      children: [
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
          child: _buildRowContentButton(
            "assets/logo/icons/editUserAccount.png",
            "ข้อมูลผู้ใช้งาน",
          ),
          onPressed:
              () => {
                postTrackClick('โปรไฟล์/ข้อมูลผู้ใช้งาน'),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserInformationPage(),
                  ),
                ),
              },
        ),

        SizedBox(height: 10),
        ButtonTheme(child: _getdata()),
        SizedBox(height: 10),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),

          child: _buildRowContentButton(
            "assets/logo/icons/editSetUpNotifications.png",
            "ตั้งค่าการแจ้งเตือน",
          ),
          onPressed:
              () => {
                postTrackClick('โปรไฟล์/ตั้งค่าการแจ้งเตือน'),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingNotificationPage(),
                  ),
                ),
              },
        ),
        // SizedBox(height: 10),
        // ButtonTheme(
        //   child: FlatButton(
        //     padding: EdgeInsets.all(0.0),
        //     child: _buildRowContentButton(
        //       "assets/logo/icons/editUserOrganization.png",
        //       "สังกัด",
        //     ),
        //     onPressed: () => {
        //       postTrackClick('โปรไฟล์/สังกัด'),
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => OrganizationPage(),
        //         ),
        //       ),
        //     },
        //   ),
        // ),
        SizedBox(height: 10),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),

          child: _buildRowContentButton(
            "assets/logo/icons/editMemberInformation.png",
            "นโยบาย",
          ),
          onPressed:
              () => {
                postTrackClick('โปรไฟล์/นโยบาย'),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    // ignore: missing_required_param
                    builder: (context) => PolicyPage(),
                  ),
                ),
              },
        ),
        SizedBox(height: 10),
        if (categorySocial == '')
          Column(
            children: [
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),

                child: _buildRowContentButton(
                  "assets/logo/icons/editChangePassword.png",
                  "เปลี่ยนรหัสผ่าน",
                ),
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordPage(),
                      ),
                    ),
              ),

              SizedBox(height: 10),
            ],
          ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
      ],
    );
  }

  _buildRowContentButton(String urlImage, String title) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Image.asset(urlImage, height: 15, width: 15),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF1B6CA8),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Image.asset("assets/logo/icons/goRight.png", height: 25, width: 25),
        ],
      ),
    );
  }

  _getdata() {
    return FutureBuilder<dynamic>(
      future: _futureProfile,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),

            child: _buildRowContentButton(
              "assets/logo/icons/editMemberInformation.png",
              snapshot.data['idcard'] != "" ? "ข้อมูลสมาชิก" : "ยืนยันตัวตน",
            ),
            onPressed:
                () => {
                  postTrackClick(
                    'โปรไฟล์/' +
                        (snapshot.data['idcard'] != ""
                            ? "ข้อมูลสมาชิก"
                            : "ลงทะเบียนข้อมูลสมาชิก"),
                  ),
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => IdentityVerificationPage(
                            title:
                                snapshot.data['idcard'] != ""
                                    ? "ข้อมูลสมาชิก"
                                    : "ลงทะเบียนข้อมูลสมาชิก",
                          ),
                      // builder: (context) => PolicyIdentityVerificationPage(),
                    ),
                  ).then(
                    (value) => {}, //readStorage(),
                  ),
                },
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Container(
              color: Colors.white,
              child: dialogFail(context, reloadApp: true),
            ),
          );
        } else {
          return Center(child: Container());
        }
      },
    );
  }

  columnYourCredits() {
    return InkWell(
      onTap:
          () => {
            postTrackClick('โปรไฟล์/หน่วยกิตของท่าน'),
            _idcard == '' || _idcard == null
                ? dialogBtn(
                  context,
                  title: 'แจ้งเตือนจากระบบ',
                  description:
                      'กรุณากรอกข้อมูลสมาชิกให้เรียบร้อยก่อนทำการตรวจสอบหน่วยกิต',
                  btnOk: "กรอกข้อมูลสมาชิก",
                  isYesNo: true,
                  callBack: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IdentityVerificationPage(),
                      ),
                    );
                  },
                )
                : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => CheckCreditsList(
                          keySearch: _idcard,
                          yearSelected: '',
                          startYear: '',
                          endYear: '',
                          licenseNumberSub: licenseNumberSub,
                        ),
                  ),
                ),
          },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFF31ACC2),
            ),
            child: Center(
              child:
                  showCredits
                      ? SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0, // กำหนดความหนาของเส้น
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ), // เปลี่ยนสีเป็นสีขาว
                        ),
                      )
                      : Text(
                        sum > 0 ? sum.toString() : 'N/A',
                        style: new TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Kanit',
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              'หน่วยกิตของท่าน',
              style: new TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kanit',
                color: Color(0xFF31ACC2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  columnEditInformation() {
    return InkWell(
      onTap:
          () => {
            postTrackClick('โปรไฟล์/แก้ไขข้อมูล'),
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditUserInformationPage(),
              ),
            ),
          },
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Color(0xFF31ACC2),
            ),
            child: Center(
              child: Image.asset('assets/logo/icons/columnEditInformation.png'),
            ),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              'แก้ไขข้อมูล',
              style: new TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'Kanit',
                color: Color(0xFF31ACC2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buttonLogout() {
    return Container(
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(5),
        width: 130,
        decoration: BoxDecoration(
          color: Color(0xFFCFDAE3),
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: () async {
            // await FacebookAuth.instance.logOut();
            postTrackClick('ออกจากระบบ');
            logout(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.power_settings_new, color: Color(0xFF1B6CA8)),
              Text(
                " ออกจากระบบ",
                style: new TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1B6CA8),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
}
