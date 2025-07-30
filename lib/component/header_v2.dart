import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:vet/pages/notification/notification_listV2.dart';

import '../shared/api_provider.dart';

headerV2(
  BuildContext context, {
  String title = '',
  int? totalnorti,
  Function? callback,
}) {
  return AppBar(
    centerTitle: false,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        color: Color(0XFFE8F6F8),
        // gradient: LinearGradient(
        //   begin: Alignment.centerLeft,
        //   end: Alignment.centerRight,
        //   colors: <Color>[
        //     Color(0XFFE8F6F8),
        //     Color(0xFF1B6CA8),
        //   ],
        // ),
      ),
    ),
    backgroundColor: Color(0xFF1B6CA8),
    elevation: 0.0,
    titleSpacing: 15,
    automaticallyImplyLeading: false,
    title: Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: new BorderRadius.circular(50),
        gradient: LinearGradient(
          colors: [Color(0xFF33B1C4), Color(0xFF1B6DA8)],
        ),
      ),
      child: Text(
        title != null ? title : '',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
    ),
    actions: <Widget>[
      InkWell(
        onTap:
            () => {
              postTrackClick('แจ้งเตือน'),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationListV2(title: 'แจ้งเตือน'),
                ),
              ).then((value) => callback!()),
            },
        child: Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(15),
            color: Color(0xFF33B1C4),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(8.0),
          child: badges.Badge(
            showBadge: (totalnorti ?? 0) > 0 ? true : false,
            position: badges.BadgePosition.topEnd(top: -5, end: -5),
            badgeContent: Text(
              totalnorti.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Image.asset('assets/noti_vet.png'),
          ),
        ),
      ),
    ],
  );
}

header(
  BuildContext context,
  Function functionGoBack, {
  String title = 'สัตวแพทยสภา',
  bool isShowLogo = true,
  bool isCenter = true,
  bool isShowButtonCalendar = false,
  bool isButtonCalendar = false,
  bool isShowButtonPoi = false,
  bool isButtonPoi = false,
  bool isElevation = false,
  Function? callBackClickButtonCalendar,
}) {
  return AppBar(
    backgroundColor: Color(0xFF1B6CA8),
    centerTitle: isCenter,
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
    elevation: isElevation == true ? 0 : 2,
    title: isCenter
        ? Text(
            title,
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 15,
            ),
          )
        : Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // if (isShowLogo)
              //   Image.asset(
              //     'assets/logo.png',
              //     height: 50,
              //   ),
              Text(
                title,
                style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              )
              // Padding(
              //   padding: EdgeInsets.only(
              //     left: 10,
              //   ),
              //   child: Text(
              //     title,
              //     style: TextStyle(fontFamily: 'Kanit', fontSize: 15),
              //   ),
              // )
            ],
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
    actions: [
      if (isShowButtonCalendar)
        GestureDetector(
          onTap: () {
            callBackClickButtonCalendar!();
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.only(right: 10, top: 12, bottom: 12),
            width: 70,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: isButtonCalendar
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list,
                        color: Color(0xFF1B6CA8),
                        size: 15,
                      ),
                      Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF1B6CA8),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/icon_header_calendar_1.png'),
                      Text(
                        'ปฏิทิน',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF1B6CA8),
                        ),
                      ),
                      // widgetText(
                      //     title: 'ปฏิทิน', fontSize: 9, color: 0xFF1B6CA8),
                    ],
                  ),
          ),
        ),
      if (isShowButtonPoi)
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 10.0),
          margin: EdgeInsets.only(right: 10, top: 12, bottom: 12),
          width: 70,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: InkWell(
            onTap: () {
              callBackClickButtonCalendar!();
            },
            child: isButtonPoi
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.list,
                        color: Color(0xFF1B6CA8),
                        size: 15,
                      ),
                      Text(
                        'รายการ',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF1B6CA8),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Color(0xFF1B6CA8),
                        size: 20,
                      ),
                      // Image.asset('assets/icon_header_calendar_1.png'),
                      Text(
                        'แผนที่',
                        style: TextStyle(
                          fontSize: 9,
                          color: Color(0xFF1B6CA8),
                        ),
                      ),
                      // widgetText(
                      //     title: 'ปฏิทิน', fontSize: 9, color: 0xFF1B6CA8),
                    ],
                  ),
          ),
        ),
    ],
  );
}

