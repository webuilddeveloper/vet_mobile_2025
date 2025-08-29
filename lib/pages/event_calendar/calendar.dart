// ignore_for_file: library_private_types_in_public_api, deprecated_member_use, prefer_interpolation_to_compose_strings

import 'dart:collection';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vet/pages/event_calendar/event_calendar_form.dart';
import 'package:vet/pages/event_calendar/event_utils.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/shared/extension.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  late ValueNotifier<List<dynamic>> _selectedEvents;
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode =
      RangeSelectionMode
          .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  late LinkedHashMap<DateTime, List<dynamic>> model;
  var markData = [];
  late Map<DateTime, List<dynamic>> itemevent;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    model = kEvents;
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    getMarkerEvent();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  getMarkerEvent() async {
    var objectData = [];
    // var value = await storage.read(key: 'dataUserLoginKSP');
    // var data = json.decode(value);
    final result = await postObjectData2(eventCalendarApi + 'mark/read2', {
      "year": DateTime.now().year,
      "organization": [],
    });
    if (result['status'] == 'S') {
      objectData = result['objectData'];

      for (int i = 0; i < objectData.length; i++) {
        if (objectData[i]['items'].length > 0) {
          markData.add(objectData[i]);
        }
      }

      itemevent = Map.fromIterable(
        markData,
        key: (item) => DateTime.parse(item['date']),
        value: (item) => item['items'],
      );

      var mainEvent = LinkedHashMap<DateTime, List<dynamic>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(itemevent);
      setState(() {
        model = mainEvent;
      });
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Implementation example
    // print('kEvents ---> $kEvents');

    // return kEvents[day] ?? [];
    return model[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: screen());
  }

  screen() {
    return Column(
      children: [
        TableCalendar<dynamic>(
          firstDay: kFirstDay,
          lastDay: kLastDay,
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarFormat: _calendarFormat,
          rangeSelectionMode: _rangeSelectionMode,
          availableGestures: AvailableGestures.all,
          eventLoader: _getEventsForDay,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleTextFormatter: (date, locale) {
              var year = date.year + 543;
              return DateFormat('MMMM พ.ศ. $year').format(date);
            },
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            weekendTextStyle: TextStyle().copyWith(
              color: Color(0xFFdec6c6),
              fontFamily: 'Sarabun',
              fontWeight: FontWeight.normal,
            ),
            holidayTextStyle: TextStyle().copyWith(
              color: Color(0xFFC5DAFC),
              fontFamily: 'Sarabun',
              fontWeight: FontWeight.normal,
            ),
          ),
          onDaySelected: _onDaySelected,
          // onRangeSelected: _onRangeSelected,
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },

          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, date, _) {
              return FadeTransition(
                opacity: Tween(
                  begin: 0.0,
                  end: 1.0,
                ).animate(_animationController),
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFC5DAFC),
                  ),
                  width: 100,
                  height: 100,
                  child: Text(
                    '${date.day}',
                    style: TextStyle().copyWith(
                      fontSize: 16.0,
                      fontFamily: 'Sarabun',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
            markerBuilder: (context, day, events) => _buildEventsMarker(events),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<dynamic>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  return eventCard(value[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEventsMarker(List events) {
    if (events.isEmpty) {
      return Container(); // or return Container() for an empty widget
    }
    return Positioned(
      bottom: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              events.length > 1
                  ? Color(0xFFa7141c)
                  : Color(0xFFa7141c).withOpacity(0.8),
        ),
        width: 16.0,
        height: 16.0,
        child: Center(
          child: Text(
            '${events.length}',
            style: TextStyle().copyWith(
              color: Colors.white,
              fontSize: 12.0,
              fontFamily: 'Sarabun',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  eventCard(event) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    EventCalendarForm(code: event['code'], model: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        padding: EdgeInsets.all(8),
        height: 110,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network('${event['imageUrl']}', fit: BoxFit.cover),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${event['title']}',
                    style: TextStyle(fontSize: 14, fontFamily: 'Sarabun'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    event['dateStart'] != '' && event['dateEnd'] != ''
                        ? dateStringToDate(event['dateStart']) +
                            " - " +
                            dateStringToDate(event['dateEnd'])
                        : '',
                    style: TextStyle(fontFamily: 'Sarabun', fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
