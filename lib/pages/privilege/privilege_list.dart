import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:vet/pages/privilege/privilege_list_vertical.dart';
import 'package:vet/shared/api_provider.dart';

class PrivilegeList extends StatefulWidget {
  PrivilegeList({
    Key? key,
    this.keySearch,
    this.category,
    this.isHighlight,
    this.title,
  }) : super(key: key);

  final String? title;
  final String? keySearch;
  final String? category;
  final bool? isHighlight;

  @override
  _PrivilegeList createState() => _PrivilegeList();
}

class _PrivilegeList extends State<PrivilegeList> {
  final storage = new FlutterSecureStorage();
  PrivilegeListVertical? gridView;
  bool hideSearch = true;
  int _limit = 0;

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    _onLoading();
    super.initState();
  }

  void _onLoading() async {
    // var profileCode = await storage.read(key: 'profileCode10');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      _limit = _limit + 10;

      gridView = new PrivilegeListVertical(
        site: 'CIO',
        model: postDio('${privilegeApi}read', {
          'skip': 0,
          'limit': _limit,
          'keySearch': widget.keySearch != null ? widget.keySearch : '',
          'isHighlight':
              widget.isHighlight != null ? widget.isHighlight : false,
          'category': widget.category != null ? widget.category : '',
          // 'profileCode': profileCode
        }),
      );
    });
    // }

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
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
        physics: ClampingScrollPhysics(), // 2nd
        children: [
          // SubHeader(th: widget.title, en: ''),
          SizedBox(height: 5.0),
          gridView ?? Container(),
        ],
      ),
    );
  }
}
