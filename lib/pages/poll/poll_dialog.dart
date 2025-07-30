import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vet/home_v2.dart';

class PollDialog extends StatefulWidget {
  PollDialog({
    Key? key,
    this.titleHome,
    this.userData,
  }) : super(key: key);

  final dynamic userData;
  final String? titleHome;

  @override
  _PollDialogState createState() => new _PollDialogState();
}

class _PollDialogState extends State<PollDialog> {
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePageV2()),
    );
    // Navigator.pop(context,false);
    // Navigator.of(context).pushAndRemoveUntil(
    //   MaterialPageRoute(
    //     builder: (context) => PollList(
    //       title: widget.titleHome,
    //       userData: widget.userData,
    //     ),
    //   ),
    //       (Route<dynamic> route) => false,
    // );
  }
}
