import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vet/component/comment.dart';
import 'package:vet/component/material/button_close_back.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/shared/extension.dart';

// ignore: must_be_immutable
class NotificationExpireForm extends StatefulWidget {
  NotificationExpireForm({
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
  _NotificationExpireForm createState() => _NotificationExpireForm();
}

class _NotificationExpireForm extends State<NotificationExpireForm> {
  Comment? comment;
  int? _limit;
  late Future<dynamic> _futureProfile;
  late int totalExpireDate;
  late String reNewTo;

  final storage = new FlutterSecureStorage();

  @override
  void initState() {
    _loading();
    super.initState();
  }

  _loading() async {
    var profileCode = await storage.read(key: 'profileCode9');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      _limit = 10;

      _futureProfile = postDio(profileReadApi, {"code": profileCode});
      // comment = Comment(
      //   code: widget.code,
      //   url: widget.urlComment,
      //   model: post('${newsCommentApi}read',
      //       {'skip': 0, 'limit': _limit, 'code': widget.code}),
      //   limit: _limit,
      // );
    });

    var _profile = await _futureProfile;
    setState(() {
      totalExpireDate = _profile['totalExpireDate'].round();
      reNewTo = _profile['reNewTo'];
    });

    // }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
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
                _listView(widget.model),
                Positioned(
                  left: 0,
                  top: (height * 0.5 / 100),
                  child: Container(
                    child: buttonCloseBack(context),
                  ),
                ),
              ],
              // overflow: Overflow.clip,
            ),
            SizedBox(
              height: 50,
            )
            // ),
            // widget.urlComment != '' ? comment : Container(),
          ],
        ),
      ),
    );
  }

  _listView(dynamic model) {
    return ListView(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        SizedBox(
          height: 5.0,
        ),
        Container(
          // color: Colors.green,
          padding: EdgeInsets.only(
            right: 10.0,
            left: 10.0,
          ),
          margin: EdgeInsets.only(left: 10.0, top: 60.0),
          child: Text(
            '${model['title']}',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B6CA8),
            ),
          ),
        ),
        model["category"] == "expireDate"
            ? Container(
                // color: Colors.green,
                padding: EdgeInsets.only(
                  right: 10.0,
                  left: 10.0,
                ),
                margin: EdgeInsets.only(left: 10.0, top: 15.0),
                child: Text(
                  'ใบอนุญาตหมดอายุวันที่ $reNewTo เหลือเวลา $totalExpireDate วัน',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            : Container(),
        model["category"] == "examPage" || model["category"] == "resultPage"
            ? Container(
                // color: Colors.green,
                padding: EdgeInsets.only(
                  right: 10.0,
                  left: 10.0,
                ),
                margin: EdgeInsets.only(left: 10.0, top: 15.0),
                child: Text(
                  model["description"],
                  style: TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.normal,
                  ),
                ),
              )
            : Container(),
        SizedBox(
          height: 10.0,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          color: Color(0xFF707070).withOpacity(0.5),
          height: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
                left: 10,
              ),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model['imageUrlCreateBy']),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['createBy']}',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 3,
                        ),
                        Row(
                          children: [
                            Text(
                              model['createSendDate'] != null
                                  ? dateStringToDate(model['createSendDate'])
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
