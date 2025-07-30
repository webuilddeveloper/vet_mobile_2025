import 'package:flutter/material.dart';

class ListContentHorizontalLoading extends StatefulWidget {
  // CardLoading({Key key, this.title}) : super(key: key);

  // final String title;

  @override
  _ListContentHorizontalLoading createState() =>
      _ListContentHorizontalLoading();
}

class _ListContentHorizontalLoading extends State<ListContentHorizontalLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  // ให้เป็น Animatable<Color> ตรง ๆ
  Animatable<Color> background = TweenSequence<Color>([
    TweenSequenceItem<Color>(
      weight: 1.0,
      tween: Tween<Color>(
        begin: Color.fromARGB(20, 0, 0, 0),
        end: Color.fromARGB(50, 0, 0, 0),
      ),
    ),
    TweenSequenceItem<Color>(
      weight: 1.0,
      tween: Tween<Color>(
        begin: Color.fromARGB(50, 0, 0, 0),
        end: Color.fromARGB(20, 0, 0, 0),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      // decoration: BoxDecoration(
      // borderRadius: new BorderRadius.circular(5),
      // color: Color(0xFF000070),
      // color: Colors.transparent),
      width: 150,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.circular(5),
              color: Color.fromARGB(50, 0, 0, 0),
            ),
          );
        },
      ),
    );
  }
}
