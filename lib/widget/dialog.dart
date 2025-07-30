import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/api_provider.dart';

dialog(BuildContext context,
    {String? title,
    String? description,
    bool isYesNo = false,
    Function? callBack}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(
            title!,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            description!,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            Container(
              color: Color(0xFF99722F),
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

dialogVersion(BuildContext context,
    {String? title,
    String? description,
    bool isYesNo = false,
    Function? callBack}) {
  return CupertinoAlertDialog(
    title: new Text(
      title!,
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'Kanit',
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
    ),
    content: Column(
      children: [
        Text(
          description!,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'เวอร์ชั่นปัจจุบัน $versionName',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    ),
    actions: [
      Container(
        color: Color(0xFF99722F),
        child: CupertinoDialogAction(
          isDefaultAction: true,
          child: new Text(
            "อัพเดท",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.normal,
            ),
          ),
          onPressed: () {
            if (isYesNo) {
              callBack!(true);
              // Navigator.pop(context, false);
            } else {
              callBack!(true);
              // Navigator.pop(context, false);
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
              "ภายหลัง",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color(0xFFFFFFFF),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              callBack!(false);
              Navigator.pop(context, false);
            },
          ),
        ),
    ],
  );
}

dialogBtn(BuildContext context,
    {String? title,
    String? description,
    bool isYesNo = false,
    String btnOk = 'ตกลง',
    String btnCancel = 'ยกเลิก',
    Function? callBack}) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: new Text(
            title!,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          content: Text(
            description!,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Kanit',
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            Container(
              color: Color(0xFF99722F),
              child: CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  btnOk,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Kanit',
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  if (isYesNo) {
                    Navigator.pop(context, false);
                    callBack!();
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
                    btnCancel,
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

dialogVetProfile(BuildContext context,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: model['photoBase64'] != '' && model['photoBase64'] != null
                    ? CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: Image.memory(base64Decode(model['photoBase64'])).image//NetworkImage(model['imageUrl']),
                      )
                    : CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.grey[300],
                        child: Image.asset(
                          'assets/vet.png',
                        ),
                      ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                // color: Colors.red,
                width: 310,
                margin: EdgeInsets.only(left: 8),
                alignment: Alignment.center,
                child: Text(
                  '${model['nameTh']} ${model['lastnameTh']}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Kanit',
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
               Container(
                // color: Colors.red,
                width: 310,
                margin: EdgeInsets.only(left: 8),
                alignment: Alignment.center,
                child: Text(
                  '${model['nameEn']} ${model['lastnameEn']}',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontFamily: 'Kanit',
                    fontSize: 20,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              // Container(
              //   margin: EdgeInsets.only(left: 8),
              //   child: Text(
              //     'สังกัด : ' +
              //         model[index]['schoolName'],
              //     style: TextStyle(
              //       color: Color(0xFF000000),
              //       fontFamily: 'Kanit',
              //       fontSize: 11,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF1B6CA8),
                ),
                alignment: Alignment.center,
                child: Text(
                  'ผู้ประกอบวิชาชีพการสัตวแพทย์ชั้น${model['category']}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Kanit',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
              //checkCertificateTeacher(model[index]),
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
