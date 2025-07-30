import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vet/component/comment.dart';
import 'package:vet/component/content.dart';
import 'package:vet/component/material/button_close_back.dart';
import 'package:vet/shared/api_provider.dart';

// ignore: must_be_immutable
class WarningForm extends StatefulWidget {
  WarningForm({
    Key? key,
    this.url,
    this.code,
    this.model,
    this.urlComment,
    this.urlGallery,
  }) : super(key: key);

  final String? url;
  final String? code;
  final dynamic model;
  final String? urlComment;
  final String? urlGallery;

  @override
  _WarningForm createState() => _WarningForm();
}

class _WarningForm extends State<WarningForm> {
  Comment? comment;
  int? _limit;

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  void _onLoading() async {
    setState(() {
      _limit = (_limit ?? 0) + 10;

      comment = Comment(
        code: widget.code,
        url: warningCommentApi,
        model: post('${warningCommentApi}read', {
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
      url: warningCommentApi,
      model: post('${warningCommentApi}read', {
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
    return Scaffold(
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
                  Content(
                    pathShare: 'content/warning/',
                    code: widget.code,
                    url: widget.url,
                    model: widget.model,
                    urlGallery: widget.urlGallery,
                    urlRotation: rotationWarningApi,
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
              if (widget.urlComment != '' && comment != null) comment!,
            ],
          ),
        ),
      ),
    );
  }
}
