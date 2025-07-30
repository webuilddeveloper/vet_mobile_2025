
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vet/component/comment.dart';
import 'package:vet/component/material/button_close_back.dart';
import 'package:vet/pages/notification/content_motifocation.dart';
import 'package:vet/shared/api_provider.dart';

// ignore: must_be_immutable
class MainPageForm extends StatefulWidget {
  MainPageForm({
    Key? key,
    this.code,
    this.model,
  }) : super(key: key);

  final String? code;
  final dynamic model;

  @override
  _MainPageForm createState() => _MainPageForm();
}

class _MainPageForm extends State<MainPageForm> {
  Comment? comment;
  int? _limit;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onLoading() async {
    setState(() {
      _limit = (_limit ?? 0) + 10;
    });

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  void initState() {
    setState(() {
      _limit = 10;
    });

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
              Stack(
                children: [
                  ContentNotification(
                    pathShare: 'content/main/',
                    code: widget.code,
                    url: notificationApi + 'detail',
                    model: widget.model,
                    urlGallery: notificationApi + 'gallery/read',
                  ),
                  Positioned(
                    left: 0,
                    top: statusBarHeight + 5,
                    child: Container(
                      child: buttonCloseBack(context),
                    ),
                  ),
                ],
              ),
              // comment,
            ],
          ),
        ),
      ),
    );
  }
}
