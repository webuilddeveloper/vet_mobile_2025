// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class YearSelectWidget extends StatefulWidget {
  const YearSelectWidget({
    Key? key,
    this.current = 0,
    this.start = 60,
    this.changed,
    this.licenseNumberSub,
  }) : super(key: key);
  final int start;
  final int current;
  final Function? changed;
  final String? licenseNumberSub;

  @override
  State<YearSelectWidget> createState() => _YearSelectWidgetState();
}

class _YearSelectWidgetState extends State<YearSelectWidget> {
  List<dynamic> yearList = [];
  int current = 0;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: current - 3);
    _setYear();
  }

  _setYear() {
    if (widget.current > 0) {
      current = widget.current;
    } else {
      current = DateTime.now().year;
    }
    int licenseNumber = int.parse(widget.licenseNumberSub ?? '0');
    int year = licenseNumber - 543;
    // for (int i = DateTime.now().year - widget.start;
    //     i <= DateTime.now().year;
    //     i++) {
    //   yearList.add(i + 543);
    // }
    for (int i = year; i <= DateTime.now().year; i = i + 5) {
      int c = ((i + 543) * 10000) + (i + 543 + 4);
      yearList.add(c);
    }
    yearList = [0, ...yearList.reversed.toList()];
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: 50,
      diameterRatio: 1.4,
      perspective: 0.005,
      // controller: ,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (value) => {
        setState(() {
          current = yearList[value];
        }),
        widget.changed!(current),
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: yearList.length,
        builder: (_, __) => Text(
          yearList[__] == 0
              ? 'ทั้งหมด'
              : yearList[__].toString().substring(0, 4) +
                  ' - ' +
                  yearList[__].toString().substring(4, 8),
          style: TextStyle(
            color: current == yearList[__]
                ? Theme.of(context).primaryColor
                : Colors.grey,
            fontSize: current == yearList[__] ? 25 : 17,
            fontWeight:
                current == yearList[__] ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
