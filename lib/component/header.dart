import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

header(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonRight = false,
  Function? rightButton,
  String menu = '', bool? isShowLogo,
}) {
  return AppBar(
    centerTitle: true,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Color(0xFF33B1C4),
            Color(0xFF1B6CA8),
          ],
        ),
      ),
    ),
    backgroundColor: Color(0xFF1B6CA8),
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: Text(
      title != null ? title : '',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
      ),
    ),
    leading: InkWell(
      onTap: () => functionGoBack(),
      child: Container(
        child: Image.asset(
          "assets/images/back_arrow.png",
          color: Colors.white,
          width: 40,
          height: 40,
        ),
      ),
    ),
    actions: <Widget>[
      isButtonRight == true
          ? menu == 'notification'
              ? Container(
                  child: Container(
                    child: Container(
                      width: 42.0,
                      height: 42.0,
                      margin:
                          EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => rightButton!(),
                        child: Image.asset('assets/images/task_list.png'),
                      ),
                    ),
                  ),
                )
              : Container(
                  child: Container(
                    child: Container(
                      width: 42.0,
                      height: 42.0,
                      margin:
                          EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => rightButton!(),
                        child: Image.asset('assets/logo/icons/Group344.png'),
                      ),
                    ),
                  ),
                )
          : Container(),
    ],
  );
}

headerV2(BuildContext context, Function functionGoBack,
    {String title = '',
    bool isButtonRight = false,
    Function? rightButton,
    String menu = '',
    int? notiCount}) {
  return AppBar(
    centerTitle: false,
    flexibleSpace: Container(),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: Row(
      children: [
        InkWell(
          onTap: () => functionGoBack(),
          child: Container(
            child: Image.asset(
              "assets/images/arrow_left.png",
              color: Color(0xFF1B6CA8),
              width: 35,
              height: 50,
            ),
          ),
        ),
        // SizedBox(width: 15),
        Text(
          title != null ? title : '',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
              color: Color(0xFF707070)),
        ),
        SizedBox(width: 15),
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.red,
          ),
          height: 30,
          width: 30,
          child: Text(
            notiCount.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
                color: Colors.white),
          ),
        ),
      ],
    ),
    actions: <Widget>[
      isButtonRight == true
          ? menu == 'notification'
              ? Container(
                  child: Container(
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      margin:
                          EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => rightButton!(),
                        child: Image.asset(
                          'assets/noti_list.png',
                          color: Color(0xFF1B6CA8),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  child: Container(
                    child: Container(
                      width: 24.0,
                      height: 24.0,
                      margin:
                          EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
                      padding: EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () => rightButton!(),
                        child: Image.asset('assets/logo/icons/Group344.png'),
                      ),
                    ),
                  ),
                )
          : Container(),
    ],
  );
}

