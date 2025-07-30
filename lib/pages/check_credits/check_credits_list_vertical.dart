import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:vet/pages/check_credits/check_credits_year_list.dart';

class CheckCreditsListVertical extends StatefulWidget {
  CheckCreditsListVertical({
    Key? key,
    this.model,
    this.idCard,
  }) : super(key: key);

  final Future<dynamic>? model;
  final String? idCard;

  @override
  _CheckCreditsListVertical createState() => _CheckCreditsListVertical();
}

class _CheckCreditsListVertical extends State<CheckCreditsListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
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
                      sum.toString(),
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontFamily: 'Kanit',
                        fontSize: 40,
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
            // SizedBox(height: 10),
            // Center(
            //   child: Text(
            //     '*อัพเดต ณ ' + dateStringToMonthYear(model[0]['readDate']),
            //     style: TextStyle(
            //       color: Color(0xFF707070),
            //       fontFamily: 'Kanit',
            //       fontSize: 11,
            //     ),
            //   ),
            // ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ประวัติกิจกรรม',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontFamily: 'Kanit',
                    fontSize: 15,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckCreditsYearList(
                          keySearch: widget.idCard,
                          yearSelected: '',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'ดูประวัติกิจกรรมรายปี',
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Kanit',
                        fontSize: 15,
                        decoration: TextDecoration.underline),
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

  //
}
