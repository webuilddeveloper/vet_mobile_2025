import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExaminationDialog extends StatefulWidget {
  ExaminationDialog({
    Key? key,
    this.titleHome,
    this.userData,
  }) : super(key: key);

  final dynamic userData;
  final String? titleHome;

  @override
  _ExaminationDialogState createState() => new _ExaminationDialogState();
}

class _ExaminationDialogState extends State<ExaminationDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.white,
      child: CupertinoAlertDialog(
        title: new Text(
          'บันทึกคำตอบเรียบร้อย',
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFF1B6CA8),
                fontWeight: FontWeight.normal,
              ),
            ),
            onPressed: () {
              goBack();
            },
          ),
        ],
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePageV2()),
    // );
    // Navigator.pop(context,false);
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => ExaminationList(
    //       title: widget.titleHome,
    //       userData: widget.userData,
    //     ),
    //   ),
    //       (Route<dynamic> route) => false,
    // );
  }
}
