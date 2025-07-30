import 'package:flutter/material.dart';
import 'package:vet/component/header_v2.dart';
import 'package:vet/pages/event_calendar/calendar.dart';
import 'package:vet/pages/event_calendar/event_calendar_list.dart';

class EventCalendarMain extends StatefulWidget {
  EventCalendarMain({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _EventCalendarMain createState() => _EventCalendarMain();
}

class _EventCalendarMain extends State<EventCalendarMain> {
  bool showCalendar = false;
  @override
  void initState() {
    super.initState();
  }

  void changeTab() async {
    // Navigator.pop(context, false);
    setState(() {
      showCalendar = !showCalendar;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        } else if (details.delta.dx < -0) {
          //Left Swipe
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: header(
          context,
          () => {Navigator.pop(context)},
          title: widget.title ?? '',
          isShowLogo: false,
          isCenter: true,
          isShowButtonCalendar: true, // เพื่อให้โชว์ปุ่มขวาบน
          isButtonCalendar: showCalendar, //ปุ่มที่เริ่มโชว์คือปุ่ม List
          callBackClickButtonCalendar: () {
            // Callback สลับปุ่มโชว์
            setState(() {
              showCalendar = !showCalendar;
            });
          },
        ),

        // headerCalendar(
        //   context,
        //   goBack,
        //   showCalendar,
        //   title: widget.title,
        //   rightButton: () => changeTab(),
        // ),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: showCalendar
              ? CalendarPage()
              : EventCalendarList(title: widget.title ?? ''),
        ),
      ),
    );
  }
}
