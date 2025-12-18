import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vet/widget/year_select.dart';

// ignore: must_be_immutable
class CheckCreditsList extends StatefulWidget {
  CheckCreditsList({
    Key? key,
    this.keySearch,
    this.yearSelected,
    this.licenseNumberSub,
    this.startYear,
    this.endYear,
  }) : super(key: key);

  final String? keySearch;
  final String? yearSelected;
  final String? licenseNumberSub;
  String? startYear;
  String? endYear;

  @override
  _CheckCreditsList createState() => _CheckCreditsList();
}

class _CheckCreditsList extends State<CheckCreditsList>
    with SingleTickerProviderStateMixin {

  String? name;
  bool hideSearch = true;
  String? keySearch;
  String? firstName;
  String? lastName;
  String yearSelected = '';
  int year = 0;
  dynamic model;
  bool isRoundCredit = true;
  bool isLoading = false;

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // สร้าง AnimationController
    _controller = AnimationController(
      duration: Duration(seconds: 2), // ระยะเวลาของการกระพริบ
      vsync: this,
    )..repeat(reverse: true); // กระพริบไป-มา

    // สร้าง Animation
    _opacityAnimation =
        Tween<double>(begin: 0.5, end: 1.0).animate(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose(); // ยกเลิก AnimationController เมื่อจบการใช้งาน
    super.dispose();
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  _readVeterinary() async {
    Dio dio = new Dio();
    var response = await dio.post(
      'https://gateway.we-builds.com/py-api/vet/member/credit/',
      data: {
        "id_card": widget.keySearch,
        "isRoundCredit": isRoundCredit,
      },
    );

    return Future.value(response.data);

    // model = await postDio(
    //     server + 'Veterinary/read/api/', {'code': widget.keySearch});
    // model = model[0];

    // print('--' + model['issueDate'].toString());
    // print('--' + model['expireDate'].toString());

    // if (widget.startYear == 'issueDate' && widget.endYear == 'expireDate') {
    //   showAll = false;
    //   issueDate = model['issueDate'];
    //   expireDate = model['expireDate'];
    // }

    // print(server + 'Veterinary/credits/read/api/');
    // print({
    //   'code': widget.keySearch,
    //   'startYear': issueDate,
    //   'endYear': expireDate,
    // }.toString());
    // return futureModel = postDio(server + 'Veterinary/credits/read/api/', {
    //   'code': widget.keySearch,
    //   'startYear': issueDate,
    //   'endYear': expireDate,
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFf2f1f3),
        // appBar: header(context, goBack, title: widget.title),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: new InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 20,
                    left: 15,
                    right: 15,
                    // bottom: 20,
                  ),
                  child: InkWell(
                    onTap: () => goBack(),
                    child: Image.asset(
                      "assets/logo/icons/backLeft.png",
                      height: 40, // Your Height
                      width: 40, // Your width
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      _build(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _build() {
    return FutureBuilder<dynamic>(
      future: _readVeterinary(), // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return _build0Data();
          } else {
            return card(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            child: Text(
              'Network ขัดข้อง',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
            ),
          );
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 300,
                ),
                AnimatedOpacity(
                  opacity: _opacityAnimation!.value, // ตั้งค่า opacity
                  duration: Duration(milliseconds: 100), // ตั้งระยะเวลา
                  child: Image.asset(
                    'assets/icon.png',
                    width: 50,
                    height: 50,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'กำลังโหลดข้อมูล หน่วยกิตของท่าน',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _build0Data() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //  ${issueDate.substring(6)} - ${expireDate.substring(6)}
              Text(
                isRoundCredit
                    ? 'ประวัติกิจกรรมรอบปัจจุบัน'
                    : 'ประวัติกิจกรรมทั้งหมด',
                // yearSelected == ''
                //     ? 'ประวัติกิจกรรมทั้งหมด'
                //     : 'ประวัติกิจกรรมปี${yearSelected.substring(0, 4)}-${yearSelected.substring(4)}',
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 16,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isRoundCredit = !isRoundCredit;
                    _readVeterinary();
                  });
                },
                child: Text(
                  isRoundCredit ? 'ดูทั้งหมด' : 'ดูรอบปัจจุบัน',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 13,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () => _buildModalSelectYear(),
              //   child: Container(
              //     child: Row(
              //       children: [
              //         Text(
              //           yearSelected == ''
              //               ? 'ทั้งหมด'
              //               : 'ปี ${yearSelected.substring(0, 4)}-${yearSelected.substring(4)}',
              //           style: TextStyle(
              //             fontSize: 17,
              //           ),
              //         ),
              //         Icon(
              //           Icons.arrow_drop_down,
              //           size: 25,
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            height: 200,
            child: Text(
              'ไม่พบข้อมูล',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  card(dynamic model) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(
                    'assets/background/bgYourTotalCredits.png',
                  ),
                )),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLoading
                          ? 'กำลังโหลดข้อมูล'
                          : model['credit'].toString(),
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Kanit',
                        fontSize: isLoading ? 14 : 40,
                      ),
                    ),
                    Text(
                      'หน่วยกิตรวมของท่าน',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF).withOpacity(0.6),
                        fontFamily: 'Kanit',
                        fontSize: 13,
                      ),
                    ),
                  ],
                )),
              ),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ${issueDate.substring(6)} - ${expireDate.substring(6)}
                Text(
                  isRoundCredit
                      ? 'ประวัติกิจกรรมรอบปัจจุบัน ${model['data']['data'][0]['IssueDate'].substring(6)} - ${model['data']['data'][0]['ExpireDate'].substring(6)}'
                      : 'ประวัติกิจกรรมทั้งหมด',
                  // yearSelected == ''
                  //     ? 'ประวัติกิจกรรมทั้งหมด'
                  //     : 'ประวัติกิจกรรมปี${yearSelected.substring(0, 4)}-${yearSelected.substring(4)}',
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isLoading = true;
                      isRoundCredit = !isRoundCredit;
                    });

                    await _readVeterinary();

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text(
                    isRoundCredit ? 'ดูทั้งหมด' : 'ดูรอบปัจจุบัน',
                    style: TextStyle(
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: model['combined_data'].length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showModalCredits(
                        context,
                        model['combined_data'][index],
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(5),
                      child: Row(
                        children: [
                          Container(
                            height: 75,
                            width: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFF3A7EB3),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                                child: Text(
                              model['combined_data'][index]['Mark'].toString(),
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontFamily: 'Kanit',
                                fontSize: 35,
                              ),
                            )),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Container(
                              height: 75,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          model['combined_data'][index]
                                                          ['ActivityName'] !=
                                                      '' &&
                                                  model['combined_data'][index]
                                                          ['ActivityName'] !=
                                                      null
                                              ? model['combined_data'][index]
                                                  ['ActivityName']
                                              : model['combined_data'][index]['ActivityNameTh'] != '' &&
                                                      model['combined_data'][index][
                                                              'ActivityNameTh'] !=
                                                          null
                                                  ? model['combined_data']
                                                      [index]['ActivityNameTh']
                                                  : model['combined_data'][index]['ActivityNameEn'] != '' &&
                                                          model['combined_data']
                                                                      [index]
                                                                  ['ActivityNameEn'] !=
                                                              null
                                                      ? model['combined_data'][index]['ActivityNameEn']
                                                      : '',
                                          style: TextStyle(
                                            color: Color(0xFF000000),
                                            fontFamily: 'Kanit',
                                            fontSize: 15,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    model['combined_data'][index]['TypeName'] !=
                                            null
                                        ? '${model['combined_data'][index]['TypeName']}'
                                        : '',
                                    style: TextStyle(
                                      color: Color(0xFF707070),
                                      fontFamily: 'Kanit',
                                      fontSize: 11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  rowTextDialog(String model, String title) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${title} : ',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontFamily: 'Kanit',
                fontSize: 13,
              ),
            ),
            Expanded(
              child: Text(
                model,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Kanit',
                  fontSize: 13,
                ),
                // overflow: TextOverflow.ellipsis,
                // maxLines: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  dialogVet(BuildContext context,
      {String? title,
      String? description,
      bool isYesNo = false,
      dynamic model,
      Function? callBack}) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Column(
              children: [
                rowTextDialog(model['activityCode'], 'รหัสกิจกรรม'),
                rowTextDialog(model['mainInstitute'], 'สถาบันหลัก'),
                rowTextDialog(model['startDate'], 'วันที่จัดกิจกรรม'),
                rowTextDialog(model['endDate'], 'วันที่สิ้นสุดจัดกิจกรรม'),
                model['place'] != null && model['place'] != ""
                    ? rowTextDialog(model['place'], 'สถานที่จัดกิจกรรม')
                    : Container(),
                model['description'] != null &&
                        model['description'] != "" &&
                        model['description'] != " " &&
                        model['description'] != " \r\n"
                    ? rowTextDialog(model['description'], 'คำอธิบาย')
                    : Container(),
                SizedBox(height: 10),
              ],
            ),
            actions: [
              Container(
                color: Color(0xFF1B6CA8),
                child: CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    if (isYesNo) {
                      callBack!();
                      Navigator.pop(context, false);
                    } else {
                      Navigator.pop(context, false);
                    }
                  },
                ),
              ),
              if (isYesNo)
                Container(
                  color: Color(0xFF707070),
                  child: CupertinoDialogAction(
                    isDefaultAction: true,
                    child: new Text(
                      "ยกเลิก",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  ),
                ),
            ],
          );
        });
  }

  showModalCredits(BuildContext context, dynamic model) async {
    showCupertinoModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Material(
            // type: MaterialType.transparency,
            child: CupertinoPageScaffold(
              child: SafeArea(
                bottom: false,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: (MediaQuery.of(context).size.height * 0.5) +
                        MediaQuery.of(context).padding.bottom,
                  ),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      ListView(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              model['TypeName'] != null
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(7),
                                        border: Border.all(
                                          color: Color(0xFFE4E4E4),
                                        ),
                                      ),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        '${model['TypeName']}',
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF707070),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Image.asset(
                                  'assets/images/close_circle.png',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Text(
                              model['ActivityName'] != '' &&
                                      model['ActivityName'] != null
                                  ? model['ActivityName']
                                  : model['ActivityNameTh'] != '' &&
                                          model['ActivityNameTh'] != null
                                      ? model['ActivityNameTh']
                                      : model['ActivityNameEn'] != '' &&
                                              model['ActivityNameEn'] != null
                                          ? model['ActivityNameEn']
                                          : '',
                              style: TextStyle(
                                color: Color(0xFF707070),
                                fontFamily: 'Kanit',
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _buildModalSelectYear() {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white.withOpacity(0.6),
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(0.75, 0),
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'กรุณาเลือกปี',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: YearSelectWidget(
                  current: year,
                  changed: (value) => year = value,
                  licenseNumberSub: widget.licenseNumberSub,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFFE4E4E4),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        yearSelected = year == 0 ? '' : year.toString();
                      });
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              CheckCreditsList(
                            keySearch: widget.keySearch,
                            yearSelected: yearSelected,
                            licenseNumberSub: widget.licenseNumberSub,
                          ),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFFE8F0F6),
                      ),
                      child: Text(
                        'ยืนยัน',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C9E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 40)
            ],
          ),
        );
      },
    );
  }
  //
}
