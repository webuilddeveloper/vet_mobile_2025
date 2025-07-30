import 'package:flutter/material.dart';
import 'package:vet/component/material/button_close_back.dart';

// ignore: must_be_immutable
class TeacherForm extends StatefulWidget {
  TeacherForm({
    Key? key,
    this.model,
  }) : super(key: key);

  final dynamic model;

  @override
  _TeacherForm createState() => _TeacherForm();
}

class _TeacherForm extends State<TeacherForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: statusBarHeight + 5,
                child: Container(
                  child: buttonCloseBack(context),
                ),
              ),
              Center(
                child: card(context, widget.model),
              ),
            ],
          ),
        ),
      ),
    );
  }

  card(BuildContext context, dynamic model) {
    return RotatedBox(
      quarterTurns: 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          // color: Colors.cyan,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: <Color>[
              Color(0xFF33B1C4),
              Color(0xFF1B6CA8),
            ],
          ),
        ),
        height: 300,
        width: 500,
        margin: EdgeInsets.only(top: 50, bottom: 50),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              // color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    height: 120,
                    width: 70,
                    child: Image(
                      image: AssetImage("assets/logo.png"),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 25),
                      // height: 80,
                      // alignment: Alignment.topCenter,
                      child: Text(
                        'บัตรประจำตัวสมาชิกสัตวแพทยสภา',
                        style: TextStyle(
                          fontSize: 18.00,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    width: 120,
                    child: model['imageUrl'] != '' && model['imageUrl'] != null
                        ? Container(
                            padding: EdgeInsets.all(5.0),
                            child: Image.network('${model['imageUrl']}'),
                          )
                        : Container(
                            margin: EdgeInsets.only(right: 15),
                            child: Image.asset(
                              'assets/vet.png',
                              // color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'ชื่อ-สกุล',
                    style: TextStyle(
                      fontSize: 20.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${model['prefixName']} ${model['firstName']} ${model['lastName']}',
                    style: TextStyle(
                      fontSize: 20.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    'ผู้ประกอบวิชาชีพการสัตวแพทย์',
                    style: TextStyle(
                      fontSize: 16.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${model['category']}',
                    style: TextStyle(
                      fontSize: 16.00,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            // Row(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(left: 15),
            //       child: Text(
            //         'เลขบัตรประจำตัวประชาชน',
            //         style: TextStyle(
            //           fontSize: 14.00,
            //           fontFamily: 'Kanit',
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //     Expanded(
            //       child: Text(
            //         '${model['idcard']}',
            //         style: TextStyle(
            //           fontSize: 14.00,
            //           fontFamily: 'Kanit',
            //           fontWeight: FontWeight.bold,
            //         ),
            //         maxLines: 1,
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: [
            //     Padding(
            //       padding: EdgeInsets.only(left: 15),
            //       child: Text(
            //         'ใบอนุญาตประกอบวิชาชีพการสัตวแพทย์ เลขที่',
            //         style: TextStyle(
            //           fontSize: 14.00,
            //           fontFamily: 'Kanit',
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 10),
            //     Expanded(
            //       child: Text(
            //         '',
            //         style: TextStyle(
            //           fontSize: 14.00,
            //           fontFamily: 'Kanit',
            //           fontWeight: FontWeight.bold,
            //         ),
            //         maxLines: 1,
            //       ),
            //     ),
            //   ],
            // ),
            // Container(
            //   alignment: Alignment.center,
            //   child: Text(
            //     '${cencer(model['codeShort'] + model['codeShortNumber'])}',
            //     style: TextStyle(
            //       fontSize: 20.00,
            //       fontFamily: 'Kanit',
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expanded(
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.stretch,
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 10),
                    //         child: Text(
                    //           'ลายเซ็นเลขาธิการสัตวแพทยสภา',
                    //           style: TextStyle(
                    //             fontSize: 14.00,
                    //             fontFamily: 'Kanit',
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 10),
                    //         child: Text(
                    //           'เลขาธิการสัตวแพทยสภา',
                    //           style: TextStyle(
                    //             fontSize: 14.00,
                    //             fontFamily: 'Kanit',
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    if (model['isOwner'])
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  model['dateOfIssue'],
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'วันออกบัตร',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  // dateStringToDateStringFormat(
                                  //     model['dateOfExplry']),
                                  model['dateOfExplry'],
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'วันหมดอายุ',
                                  style: TextStyle(
                                    fontSize: 14.00,
                                    fontFamily: 'Kanit',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cencer(param) {
    if (param != '') {
      var fst = param.substring(0, 2);
      var lst = param.substring(param.length - 2);
      return param.replaceAll(fst, 'XX').replaceAll(lst, 'XX');
    } else {
      return '-';
    }
  }
}
