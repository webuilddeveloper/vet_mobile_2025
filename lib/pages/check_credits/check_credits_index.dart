import 'package:flutter/material.dart';
import 'package:vet/component/header_v2.dart';
import 'package:vet/component/material/button_full.dart';
import 'package:vet/pages/blank_page/dialog_fail.dart';
import 'package:vet/pages/check_credits/check_credits_list.dart';

class BuildCheckCreditsIndex extends StatefulWidget {
  BuildCheckCreditsIndex({
    Key? key,
    this.menuModel,
    this.model,
    this.title,
  }) : super(key: key);

  final Future<dynamic>? model;
  final Future<dynamic>? menuModel;
  final String? title;

  @override
  BuildCheckCreditsIndexState createState() => BuildCheckCreditsIndexState();
}

class BuildCheckCreditsIndexState extends State<BuildCheckCreditsIndex> {
  dynamic _tempModel = {'imageUrl': '', 'firstName': '', 'lastName': ''};
  final textEditingController = TextEditingController();

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
        appBar: header(context, () => {Navigator.pop(context)},
            title: widget.title ?? ''),
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
                  child: Center(
                    child: Text('Network ขัดข้อง'),
                  ),
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
              'ค้นหาข้อมูลหน่วยกิต',
              style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
          ),
          Container(
            child: Text(
              'กรุณากรอกเลขบัตรประชาชนที่ท่านต้องการตรวจสอบ',
              style: TextStyle(
                fontFamily: 'Kanit',
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      'เลขบัตรประชาชน',
                      style: TextStyle(
                        fontFamily: 'Kanit',
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    obscureText: false,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 16.0,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF7090AC),
                      contentPadding: EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
                      hintText: 'กรุณาเลขบัตรประชาชน',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
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
                  SizedBox(
                    height: 20,
                  ),
                  buttonFull(
                    title: 'ค้นหา',
                    backgroundColor: Theme.of(context).primaryColor,
                    fontColor: Colors.white,
                    callback: () => {checkIDCardEmpty()},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkIDCardEmpty() {
    FocusScope.of(context).unfocus();
    if (textEditingController.text != '') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CheckCreditsList(
            keySearch: textEditingController.text,
            yearSelected: '',
            startYear: '',
            endYear: '',
            // licenseNumberSub: licenseNumberSub,
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
