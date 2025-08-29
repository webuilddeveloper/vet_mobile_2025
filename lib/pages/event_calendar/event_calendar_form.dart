// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vet/component/comment.dart';
import 'package:vet/component/contentEventCalendar.dart';
import 'package:vet/component/material/button_close_back.dart';
import 'package:vet/shared/api_provider.dart';

// ignore: must_be_immutable
class EventCalendarForm extends StatefulWidget {
  const EventCalendarForm({
    super.key,
    this.url,
    this.code,
    this.model,
    this.urlComment,
    this.urlGallery,
  });

  final String? url;
  final String? code;
  final dynamic model;
  final String? urlComment;
  final String? urlGallery;

  @override
  _EventCalendarForm createState() => _EventCalendarForm();
}

class _EventCalendarForm extends State<EventCalendarForm> {
  late Comment comment;
  int? _limit;

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onLoading() async {
    setState(() {
      _limit = (_limit ?? 0) + 10;

      comment = Comment(
        code: widget.code,
        url: eventCalendarCommentApi,
        model: postDio('${eventCalendarCommentApi}read', {
          'skip': 0,
          'limit': _limit,
          'code': widget.code,
        }),
        limit: _limit,
      );
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

    comment = Comment(
      code: widget.code,
      url: eventCalendarCommentApi,
      model: post('${eventCalendarCommentApi}read', {
        'skip': 0,
        'limit': _limit,
        'code': widget.code,
      }),
      limit: _limit,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
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
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowIndicator();
            return false;
          },
          child: SmartRefresher(
            enablePullDown: false,
            enablePullUp: true,
            footer: ClassicFooter(
              loadingText: ' ',
              canLoadingText: ' ',
              idleText: ' ',
              idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
            ),
            controller: _refreshController,
            onLoading: _onLoading,
            child: ListView(
              shrinkWrap: true,
              children: [
                // Expanded(
                //   child:
                Stack(
                  // fit: StackFit.expand,
                  // alignment: AlignmentDirectional.bottomCenter,
                  // shrinkWrap: true,
                  // physics: ClampingScrollPhysics(),
                  children: [
                    ContentEventCalendar(
                      pathShare: 'content/eventCalendar/',
                      code: widget.code,
                      model: widget.model,
                      urlGallery: eventCalendarGalleryApi,
                      url: '${eventCalendarApi}read',
                      urlRotation: rotationEvantCalendarApi,
                    ),
                    Positioned(
                      left: 0,
                      top: statusBarHeight + 5,
                      child: Container(child: buttonCloseBack(context)),
                    ),
                  ],
                  // overflow: Overflow.clip,
                ),
                // ),
                widget.urlComment != '' ? comment : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
