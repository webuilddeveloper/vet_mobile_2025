import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vet/component/header.dart';
import 'package:vet/component/material/button_full.dart';
import 'package:vet/pages/blank_page/dialog_fail.dart';
import 'package:vet/pages/teacher/teacher/teacher_list.dart';

class BuildTeacherIndex extends StatefulWidget {
  BuildTeacherIndex({Key? key, this.menuModel, this.model, this.title})
    : super(key: key);

  final Future<dynamic>? model;
  final Future<dynamic>? menuModel;
  final String? title;

  @override
  BuildTeacherIndexState createState() => BuildTeacherIndexState();
}

class BuildTeacherIndexState extends State<BuildTeacherIndex> {
  dynamic _tempModel = {'imageUrl': '', 'firstName': '', 'lastName': ''};
  final textEditingController = TextEditingController();
  bool selectPDPA = false;

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Colors.white,
        appBar: header(
          context,
          () => {Navigator.pop(context)},
          title: widget.title ?? '',
        ),
        body: new InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: FutureBuilder<dynamic>(
            future: widget.menuModel,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return screen(snapshot.data, false);
              } else if (snapshot.hasError) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  height: 90,
                  child: Center(child: Text('Network ขัดข้อง')),
                );
              } else {
                return screen(_tempModel, true);
              }
            },
          ),
        ),
      ),
    );
  }

  screen(dynamic model, bool isLoading) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'ค้นหาข้อมูลสัตวแพทย์',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            child: Text(
              'กรุณากรอกชื่อหรือนามสกุลของสัตวแพทย์ที่ท่านต้องการตรวจสอบ',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            // margin: EdgeInsets.symmetric(
            //   vertical: 5.0,
            //   horizontal: 15.0,
            // ),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xFF1B6CA8)),
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Colors.white,
            ),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                'ยอมรับการให้ข้อมูล โดยข้อมูลที่ท่านกรอกจะเป็นการคุ้มครองข้อมูลส่วนบุคคล ตามพระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ.2562',
                style: TextStyle(
                  fontSize: 13.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.w300,
                ),
              ),
              value: selectPDPA,
              onChanged: (bool? value) {
                setState(() {
                  selectPDPA = value ?? false;
                });
              },
              activeColor: Color(0xFF1B6CA8),
              checkColor: Colors.white,
            ),
          ),
          // Container(
          //   child: Text(
          //     'เพื่อเป็นการคุ้มครองข้อมูลส่วนบุคคล ตามพระราชบัญญัติคุ้มครองข้อมูลส่วนบุคคล พ.ศ.2562 ผู้ที่จะทำการค้นหารายชื่อผู้ประกอบวิชาชีพการสัตวแพทย์ ',
          //     style: TextStyle(
          //       fontFamily: 'Kanit',
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),
          SizedBox(height: 30),
          Center(
            child: Container(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'ชื่อ นามสกุล',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  TextFormField(
                    enabled: selectPDPA,
                    obscureText: false,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:
                          selectPDPA == true ? Color(0xFF7090AC) : Colors.grey,
                      contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
                      hintText: 'กรุณากรอกชื่อหรือนามสกุล',
                      hintStyle: TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                        fontSize: 10.0,
                      ),
                    ),
                    controller: textEditingController,
                  ),
                  SizedBox(height: 20),
                  buttonFull(
                    title: 'ค้นหา',
                    backgroundColor:
                        selectPDPA == true
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                    fontColor: Colors.white,
                    callback:
                        () => {selectPDPA == true ? checkNameEmpty() : null},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkNameEmpty() {
    FocusScope.of(context).unfocus();
    if (textEditingController.text != '') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => TeacherList(
                keySearch: textEditingController.text,
                title: widget.title,
              ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialogFailTeacher(
            context,
            title: 'กรุณากรอกชื่อหรือนามสกุล',
            background: Colors.transparent,
          );
        },
      );
    }
  }

  // .end
}
