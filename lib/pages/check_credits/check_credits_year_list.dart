import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/widget/year_select.dart';

class CheckCreditsYearList extends StatefulWidget {
  CheckCreditsYearList({
    Key? key,
    this.keySearch,
    this.yearSelected,
  }) : super(key: key);

  final String? keySearch;
  final String? yearSelected;

  @override
  _CheckCreditsYearList createState() =>
      _CheckCreditsYearList();
}

class _CheckCreditsYearList extends State<CheckCreditsYearList> {

  String? name;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  String? keySearch;
  String? firstName;
  String? lastName;
  String yearSelected = '';
  Future<dynamic>? futureModel;
  int year = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var now = new DateTime.now();
    year = now.year + 543;
    if (widget.yearSelected != '') {
      yearSelected = widget.yearSelected!;
    } else {
      yearSelected = year.toString();
    }
  }

  read() {
    return futureModel = postDio(server + 'Veterinary/credits/read/api/',
        {'code': widget.keySearch, 'yearSelected': yearSelected});
  }

  void goBack() async {
    Navigator.pop(context, false);
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
                SizedBox(height: 10),
                _buildYearlyActivityHistory(),
                _buildModel(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildYearlyActivityHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ประวัติกิจกรรมรายปี',
            style: TextStyle(
              color: Color(0xFF000000),
              fontFamily: 'Kanit',
              fontSize: 15,
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () => _buildModalSelectYear(),
            child: Container(
              child: Row(
                children: [
                  Text(
                    ' ปี $yearSelected',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 25,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildModel() {
    return Expanded(
      child: ListView(
        padding: EdgeInsets.zero,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: [
          FutureBuilder<dynamic>(
            future: read(), // function where you call your api
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Container(
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
                  );
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
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  card(dynamic model) {
    double sum = 0;
    model.forEach((o) => sum += o['mark']);
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: model.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      showModalCredits(
                        context,
                        model[index],
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
                              model[index]['mark'].toString(),
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
                                          model[index]['activityName'] != '' &&
                                                  model[index]
                                                          ['activityName'] !=
                                                      null
                                              ? model[index]['activityName']
                                              : model[index]['activityNameTh'] !=
                                                          '' &&
                                                      model[index][
                                                              'activityNameTh'] !=
                                                          null
                                                  ? model[index]
                                                      ['activityNameTh']
                                                  : model[index]['activityNameEn'] !=
                                                              '' &&
                                                          model[index][
                                                                  'activityNameEn'] !=
                                                              null
                                                      ? model[index]
                                                          ['activityNameEn']
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
                                    model[index]['typeName'] != null
                                        ? '${model[index]['typeName']}'
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
                              model['typeName'] != null
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
                                        '${model['typeName']}',
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
                              model['activityName'] != '' &&
                                      model['activityName'] != null
                                  ? model['activityName']
                                  : model['activityNameTh'] != '' &&
                                          model['activityNameTh'] != null
                                      ? model['activityNameTh']
                                      : model['activityNameEn'] != '' &&
                                              model['activityNameEn'] != null
                                          ? model['activityNameEn']
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
    int year = 2561;
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
              )),
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
                        yearSelected = year.toString();
                      });
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              CheckCreditsYearList(
                            keySearch: widget.keySearch,
                            yearSelected: yearSelected,
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
