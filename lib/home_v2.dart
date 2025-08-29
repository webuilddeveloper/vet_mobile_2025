// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures, prefer_typing_uninitialized_variables, deprecated_member_use, library_private_types_in_public_api

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vet/component/carouselBannerDotStack.dart';
import 'package:vet/component/carousel_form.dart';
import 'package:vet/component/header_v2.dart';
import 'package:vet/component/link_url_out.dart';
import 'package:vet/main_popup_dialog.dart';
import 'package:vet/pages/about_us/about_us_form.dart';
import 'package:vet/pages/blank_page/toast_fail.dart';
import 'package:vet/pages/check_credits/check_credits_list.dart';
import 'package:vet/pages/contact/contact_list_category.dart';
import 'package:vet/pages/ebook/ebook_list.dart';
import 'package:vet/pages/enfranchise/enfrancise_main.dart';
import 'package:vet/pages/event_calendar/event_calendar_main.dart';
import 'package:vet/pages/knowledge/knowledge_list.dart';
import 'package:vet/pages/news/news_list.dart';
import 'package:vet/pages/notification/notification_listV2.dart';
import 'package:vet/pages/policy_v2.dart';
import 'package:vet/pages/poll/poll_list.dart';
import 'package:vet/pages/privilege/privilege_main.dart';
import 'package:vet/pages/privilegeSpecial/privilege_special_list.dart';
import 'package:vet/pages/profile/identity_verification.dart';
import 'package:vet/pages/profile/profile.dart';
import 'package:vet/pages/profile/user_information.dart';
import 'package:vet/pages/teacher/teacher/teacher_index.dart';
import 'package:vet/widget/dialog.dart';
import 'shared/api_provider.dart';

class HomePageV2 extends StatefulWidget {
  const HomePageV2({super.key});

  @override
  _HomePageV2State createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _addBadger();
    });
  }

  final storage = FlutterSecureStorage();
  late DateTime currentBackPressTime;

  Future<dynamic>? _futureBanner;
  Future<dynamic>? _futureProfile;
  Future<dynamic>? _futureOrganizationImage;
  Future<dynamic>? _futureMenu;
  Future<dynamic>? _futureAboutUs;
  Future<dynamic>? _futureMainPopUp;
  Future<dynamic>? _futureNoti;
  dynamic _policyMarketing;

  int addBadger = 0;

  // String currentLocation = '-';
  final seen = <String>{};
  List unique = [];
  List imageLv0 = [];

  bool notShowOnDay = false;
  bool hiddenMainPopUp = false;
  bool checkDirection = false;
  LatLng latLng = LatLng(0, 0);

  dynamic _isNewsCount = false;
  dynamic _isEventCount = false;
  dynamic _isPollCount = false;
  dynamic _isPrivilegeCount = false;

  dynamic lcCategory = false;
  int nortiCount = 0;
  String _idcard = '';
  String _licenseNumber = '';
  String? licenseNumberSub;
  // dynamic _newsPage;
  // dynamic _eventPage;
  // dynamic _privilegePage;
  // dynamic _knowledgePage;
  // dynamic _poiPage;
  // dynamic _notificationPage;

  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  late StreamSubscription<Map> _notificationSubscription;

  @override
  void initState() {
    _read();
    super.initState();
    // NotificationService.instance.start(context);
    // _notificationSubscription = NotificationsBloc.instance.notificationStream
    //     .listen(_performActionOnNotificationV2);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _notificationSubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      appBar: headerV2(
        context,
        title: "สัตวแพทยสภา",
        totalnorti: nortiCount,
        callback: _readNoti,
      ),
      body: WillPopScope(
        onWillPop: confirmExit,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: _buildBackground(),
        ),
      ),
    );
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastFail(
        context: context,
        text: 'กดอีกครั้งเพื่อออก',
        backgroundColor: Colors.black,
        fontColor: Colors.white,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF7F7F7),
        // gradient: LinearGradient(
        //   colors: [
        //     Color(0xFF1B6CA8),
        //     Color(0xFF1B6CA8),
        //     Color(0xFFFFFFFF),
        //   ],
        //   begin: Alignment.topCenter,
        //   // end: new Alignment(1, 0.0),
        //   end: Alignment.bottomCenter,
        // ),
      ),
      child: _buildNotificationListener(),
    );
  }

  _buildNotificationListener() {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overScroll) {
        overScroll.disallowIndicator();
        return false;
      },
      child: _buildMenu(),
      // child: _buildSmartRefresher(),
    );
  }

  _buildMenu() {
    return FutureBuilder<dynamic>(
      future: _futureMenu, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              complete: Container(child: Text('')),
              completeDuration: Duration(milliseconds: 0),
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView(
              children: [
                Container(
                  //height: 270,
                  // height: (MediaQuery.of(context).size.height / 100) * 31,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                    color: Color(0XFFE8F6F8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: _buildProfile(),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'ประชาสัมพันธ์',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: _buildBanner(),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'บริการทั้งหมด',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                ...snapshot.data
                    .map<Widget>((e) => _buildButtonMenu(e))
                    .toList(),
                // _buildButtonMenu(snapshot.data[0]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[1]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[2]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[3]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[4]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[5]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[6]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[7]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[8]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[9]),
                // SizedBox(height: 3),
                // _buildButtonMenu(snapshot.data[10]),
                SizedBox(height: 40),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildButtonMenu(dynamic model) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              postTrackClick(model['title']);
              switch (model['code']) {
                case 'VERIFY_VET':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => BuildTeacherIndex(title: model['title']),
                    ),
                  );
                  break;
                case 'DOWNLOAD':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EbookList(title: model['title']),
                    ),
                  );
                  break;
                case 'OTHERBENFITS':
                  storage.write(
                    key: 'isBadgerPrivilege',
                    value: '0', //_isPrivilegeCount.toString(),
                  );
                  setState(() {
                    _isPrivilegeCount = false;
                    _addBadger();
                  });
                  _callReadPolicyPrivilege(model['title'], _policyMarketing);
                  break;
                case 'PRIVILEGESPECIAL':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              PrivilegeSpecialList(title: model['title']),
                    ),
                  );
                  break;
                case 'NEWS':
                  storage.write(
                    key: 'isBadgerNews',
                    value: '0', //_newsCount.toString(),
                  );
                  setState(() {
                    _isNewsCount = false;
                    _addBadger();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsList(title: model['title']),
                    ),
                  );
                  break;
                case 'EVENT':
                  storage.write(
                    key: 'isBadgerEvent',
                    value: '0', //_eventCount.toString(),
                  );
                  setState(() {
                    _isEventCount = false;
                    _addBadger();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => EventCalendarMain(title: model['title']),
                    ),
                  );
                  break;
                case 'KNOWLEDGE':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => KnowledgeList(title: model['title']),
                    ),
                  );
                  break;
                case 'POLL':
                  storage.write(
                    key: 'isBadgerPoll',
                    value: '0', //_pollCount.toString(),
                  );
                  setState(() {
                    _isPollCount = false;
                    _addBadger();
                  });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PollList(title: model['title']),
                    ),
                  );
                  break;
                case 'CONTACT':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ContactListCategory(title: model['title']),
                    ),
                  );
                  break;
                case 'ABOUT_US':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AboutUsForm(
                            model: _futureAboutUs,
                            title: model['title'],
                          ),
                    ),
                  );
                  break;
                case 'CHECK_CREDITS':
                  model['vetCategory'] != '' && model['vetCategory'] != null
                      ? model['vetCategory'] == 'ทั่วไป'
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
                                  builder:
                                      (context) => IdentityVerificationPage(),
                                ),
                              ).then((value) => _read());
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
                          )
                      : dialogBtn(
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
                      );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => BuildCheckCreditsIndex(
                  //       title: model['title'],
                  //     ),
                  //   ),
                  // );
                  break;
                default:
              }
            },
            child:
                (model['code'] != '')
                    ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      height: (MediaQuery.of(context).size.height / 100) * 12,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: Image.network(
                          model['imageUrl'],
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
                    : Container(),
          ),
          Positioned(
            top: 5,
            right: 15,
            child:
                (model['code'] == "NEWS" && _isNewsCount) ||
                        (model['code'] == "EVENT" && _isEventCount) ||
                        (model['code'] == "POLL" && _isPollCount) ||
                        (model['code'] == "OTHERBENFITS" && _isPrivilegeCount)
                    ? Container(
                      alignment: Alignment.center,
                      width: 30,
                      // height: 90.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.red,
                      ),
                      child: Text(
                        'N',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                    : Container(),
          ),
        ],
      ),
    );
  }

  _buildBanner() {
    return
    // CarouselBanner(
    //   model: _futureBanner,
    //   //height: 100,
    //   height: (MediaQuery.of(context).size.height / 100) * 10,
    //   nav: (String path, String action, dynamic model, String code,
    //       String urlGallery) {
    //     if (action == 'out') {
    //       // launchInWebViewWithJavaScript(path);
    //       launchURL(path);
    //     } else if (action == 'in') {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => CarouselForm(
    //             code: code,
    //             model: model,
    //             url: mainBannerApi,
    //             urlGallery: bannerGalleryApi,
    //           ),
    //         ),
    //       );
    //     }
    //   },
    // );
    CarouselBannerDotStack(
      height: (MediaQuery.of(context).size.height / 100) * 15,
      model: _futureBanner,
      nav: (
        String path,
        String action,
        dynamic model,
        String code,
        String urlGallery,
      ) {
        postTrackClick('แบนเนอร์');
        if (action == 'out') {
          // launchInWebViewWithJavaScript(path);
          launchURL(path);
        } else if (action == 'in') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => CarouselForm(
                    code: code,
                    model: model,
                    url: mainBannerApi,
                    urlGallery: bannerGalleryApi,
                  ),
            ),
          );
        } else if (action.toUpperCase() == 'P') {
          postDio('${server}m/Rotation/innserlog', model);
          _callReadPolicyPrivilegeAtoZ(code);
        }
      },
    );
  }

  // _buildCurrentLocationBar() {
  //   return Container(
  //     color: Color(0xFF000070),
  //     // padding: EdgeInsets.symmetric(horizontal: 5),
  //     padding: EdgeInsets.all(5),
  //     height: 25,
  //     child: Text(
  //       'พื้นที่ปัจจุบัน : ' + currentLocation,
  //       style: TextStyle(
  //         fontFamily: 'Kanit',
  //         fontSize: 10,
  //         color: Colors.white,
  //       ),
  //     ),
  //   );
  // }

  _buildProfile() {
    return Profile(
      model: _futureProfile,
      organizationImage: _futureOrganizationImage,
      nav: () {
        postTrackClick('โปรไฟล์');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserInformationPage()),
        ).then((value) => _read());
      },
      nav1: () {
        postTrackClick('แจ้งเตือน');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationListV2(title: 'แจ้งเตือน'),
          ),
        ).then((value) => _read());
      },
    );
  }

  _readNoti() async {
    var profile = await _futureProfile;
    dynamic username = profile["username"];
    _futureNoti = postDio('${notificationApi}count', {"username": username});
    var norti = await _futureNoti;
    setState(() {
      nortiCount = norti['total'];
    });
  }

  _read() async {
    //read profile
    _callReadPolicy();
    var profileCode = await storage.read(key: 'profileCode10');
    if (profileCode != '' && profileCode != null) {
      setState(() {
        _futureProfile = postDio(profileReadApi, {"code": profileCode});
        // _futureNotiExam = postDio('${notificationApi}readExam', {});
        _futureOrganizationImage = postDio(organizationImageReadApi, {
          "code": profileCode,
        });
      });
    } else {
      logout(context);
    }

    _futureMenu = postDio('${menuApi}read', {'limit': 100});
    _futureBanner = postDio('${mainBannerApi}read', {'limit': 10});
    _futureMainPopUp = postDio('${mainPopupHomeApi}read', {'limit': 10});
    _futureAboutUs = postDio('${aboutUsApi}read', {});
    // _futureEventCalendar = postDio('${eventCalendarApi}read', {'limit': 10});
    // _futureNews = postDio('${newsApi}read', {'limit': 10});
    // _futureKnowledge = postDio('${knowledgeApi}read', {'limit': 10});
    _policyMarketing = await postDio("${server}m/policy/read", {
      "category": "marketing",
      "skip": 0,
      "limit": 10,
    });
    var profile = await _futureProfile;
    dynamic username = profile["username"];
    _idcard = profile["idcard"];
    _licenseNumber = profile["licenseNumber"];
    licenseNumberSub = _licenseNumber.substring(8);
    _futureNoti = postDio('${notificationApi}count', {"username": username});
    var norti = await _futureNoti;

    setState(() {
      nortiCount = norti['total'];
    });

    //get api Count
    // _newsCount = await postDio(newsApi + 'count', {});
    // _eventCount = await postDio(eventCalendarApi + 'count', {});
    // _pollCount = await postDio(pollApi + 'count', {});
    // //get storage
    // int storageNewsCount =
    //     int.parse(await storage.read(key: 'newsCount') ?? '0');
    // int storageEventCount =
    //     int.parse(await storage.read(key: 'eventCount') ?? '0');
    // int storagePollCount =
    //     int.parse(await storage.read(key: 'pollCount') ?? '0');

    // _isNewsCount = _newsCount > storageNewsCount ? true : false;
    // _isEventCount = _eventCount > storageEventCount ? true : false;
    // _isPollCount = _pollCount > storagePollCount ? true : false;

    _addBadger();

    // _buildMainPopUp();
    // _getLocation();
  }

  _addBadger() async {
    String? storageNewsCount = await storage.read(key: 'isBadgerNews');
    String? storageEventCount = await storage.read(key: 'isBadgerEvent');
    String? storagePollCount = await storage.read(key: 'isBadgerPoll');
    String? storagePrivilegeCount = await storage.read(
      key: 'isBadgerPrivilege',
    );
    _isNewsCount = storageNewsCount == '1' ? true : false;
    _isEventCount = storageEventCount == '1' ? true : false;
    _isPollCount = storagePollCount == '1' ? true : false;
    _isPrivilegeCount = storagePrivilegeCount == '1' ? true : false;

    if (_isNewsCount && _isEventCount && _isPollCount && _isPrivilegeCount) {
      addBadger = 4;
    } else if ((_isNewsCount && _isEventCount && _isPollCount) ||
        (_isNewsCount && _isEventCount && _isPrivilegeCount) ||
        (_isNewsCount && _isPollCount && _isPrivilegeCount) ||
        (_isEventCount && _isPollCount && _isPrivilegeCount))
      addBadger = 3;
    else if ((_isNewsCount && _isEventCount) ||
        (_isNewsCount && _isPollCount) ||
        (_isNewsCount && _isPrivilegeCount) ||
        (_isPollCount && _isEventCount) ||
        (_isPollCount && _isPrivilegeCount) ||
        (_isEventCount && _isPrivilegeCount))
      addBadger = 2;
    else if (_isNewsCount || _isEventCount || _isPollCount || _isPrivilegeCount)
      addBadger = 1;
    else
      addBadger = 0;

    // FlutterAppBadger.updateBadgeCount(add_badger);

    _updateBadgerStorage('isBadgerNews', _isNewsCount ? '1' : '0');
    _updateBadgerStorage('isBadgerEvent', _isEventCount ? '1' : '0');
    _updateBadgerStorage('isBadgerPoll', _isPollCount ? '1' : '0');
    _updateBadgerStorage('isBadgerPrivilege', _isPrivilegeCount ? '1' : '0');
  }

  _updateBadgerStorage(String keyTitle, String isActive) {
    storage.write(key: keyTitle, value: isActive);
  }

  _buildMainPopUp() async {
    var result = await post('${mainPopupHomeApi}read', {'limit': 100});

    if (result.length > 0) {
      var valueStorage = await storage.read(key: 'mainPopupDDPM');
      var dataValue;
      if (valueStorage != null) {
        dataValue = json.decode(valueStorage);
      } else {
        dataValue = null;
      }

      var now = DateTime.now();
      DateTime date = DateTime(now.year, now.month, now.day);

      if (dataValue != null) {
        var index = dataValue.indexWhere(
          (c) =>
              // c['username'] == userData.username &&
              c['date'].toString() ==
                  DateFormat("ddMMyyyy").format(date).toString() &&
              c['boolean'] == "true",
        );

        if (index == -1) {
          setState(() {
            hiddenMainPopUp = false;
          });
          return showDialog(
            barrierDismissible: false, // close outside
            context: context,
            builder: (_) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: MainPopupDialog(
                  model: _futureMainPopUp,
                  type: 'mainPopup',
                ),
              );
            },
          );
        } else {
          setState(() {
            hiddenMainPopUp = true;
          });
        }
      } else {
        setState(() {
          hiddenMainPopUp = false;
        });
        return showDialog(
          barrierDismissible: false, // close outside
          context: context,
          builder: (_) {
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: MainPopupDialog(
                model: _futureMainPopUp,
                type: 'mainPopup',
              ),
            );
          },
        );
      }
    }
  }

  void _onRefresh() async {
    // getCurrentUserData();
    // _getLocation();
    _read();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  // _getLocation() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.best);

  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       position.latitude, position.longitude,
  //       localeIdentifier: 'th');

  //   setState(() {
  //     latLng = LatLng(position.latitude, position.longitude);
  //     currentLocation = placemarks.first.administrativeArea;
  //   });
  // }

  // _performActionOnNotification(Map<String, dynamic> message) async {
  //   // Navigator.push(
  //   //   context,
  //   //   MaterialPageRoute(
  //   //     builder: (context) => NotificationList(
  //   //       title: 'แจ้งเตือน',
  //   //     ),
  //   //   ),
  //   // );
  // }

  Future<Null> _callReadPolicy() async {
    var policy = await postDio("${server}m/policy/read", {
      "category": "application",
      "skip": 0,
      "limit": 10,
    });

    if (policy.length > 0) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:
              (context) => PolicyV2Page(
                category: 'application',
                navTo: () {
                  // Navigator.pop(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePageV2()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      _buildMainPopUp();
    }
  }

  Future<Null> _callReadPolicyPrivilege(String title, dynamic model) async {
    if (model.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => PolicyV2Page(
                category: 'marketing',
                navTo: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivilegeMain(title: title),
                    ),
                  );
                },
              ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PrivilegeMain(title: title)),
      );
    }

    return Future.value(); // Ensures a non-null Future is returned
  }

  Future<Null> _callReadPolicyPrivilegeAtoZ(code) async {
    var policy = await postDio("${server}m/policy/readAtoZ", {
      "reference": "AtoZ",
    });
    if (policy.length <= 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          // ignore: missing_required_param
          // builder: (context) => PolicyIdentityVerificationPage(),
          builder:
              (context) => PolicyV2Page(
                category: 'AtoZ',
                navTo: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnfranchiseMain(reference: code),
                    ),
                  );
                },
              ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnfranchiseMain(reference: code),
        ),
      );
    }
  }

  // mainFooter() {
  //   double width = MediaQuery.of(context).size.width;
  //   double height = MediaQuery.of(context).size.height;
  //   return Container(
  //     height: height * 15 / 100,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           Color(0xFF1B6CA8),
  //           Color(0xFFF7E834),
  //         ],
  //         begin: Alignment.topLeft,
  //         end: new Alignment(1, 0.0),
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.max,
  //       crossAxisAlignment: CrossAxisAlignment.stretch,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Container(
  //           alignment: Alignment.center,
  //           child: Text(
  //             userData.status == 'N'
  //                 ? 'ท่านยังไม่ได้ยืนยันตัวตน กรุณายืนยันตัวตน'
  //                 : 'ยืนยันตัวตนแล้ว รอเจ้าหน้าที่ตรวจสอบข้อมูล',
  //             style: TextStyle(
  //               // color: Colors.white,
  //               fontFamily: 'Kanit',
  //               fontSize: 13,
  //             ),
  //           ),
  //         ),
  //         SizedBox(
  //           height: height * 1.5 / 100,
  //         ),
  //         userData.status == 'N'
  //             ? Container(
  //                 margin: EdgeInsets.symmetric(horizontal: width * 34 / 100),
  //                 height: height * 6 / 100,
  //                 child: Material(
  //                   elevation: 5.0,
  //                   borderRadius: BorderRadius.circular(10.0),
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(5.0),
  //                       color: Theme.of(context).primaryColorDark,
  //                     ),
  //                     child: MaterialButton(
  //                       minWidth: MediaQuery.of(context).size.width,
  //                       onPressed: () {
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => IdentityVerificationPage(),
  //                           ),
  //                         );
  //                       },
  //                       child: Text(
  //                         'ยืนยันตัวตน',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontFamily: 'Kanit',
  //                           fontSize: 13,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               )
  //             : Container(),
  //       ],
  //     ),
  //   );
  // }
}
