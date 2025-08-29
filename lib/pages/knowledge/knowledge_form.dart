import 'dart:ui';
import 'package:flutter_html/flutter_html.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:vet/component/link_url_in.dart';
import 'package:vet/component/link_url_out.dart';
import 'package:vet/component/loading_image_network.dart';
import 'package:vet/pages/examination/examination_list_vertical.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/shared/extension.dart';

class KnowledgeForm extends StatefulWidget {
  KnowledgeForm({Key? key, this.code, this.model, this.urlComment})
    : super(key: key);
  final String? code;
  final dynamic? model;
  final String? urlComment;

  @override
  _KnowledgeDetailPageState createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeForm> {
  Future<dynamic>? _futureModel;

  String? code;
  ExaminationListVertical? examination;
  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    _onLoading();
    _futureModel = post('${knowledgeApi}read', {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
  }

  void _onLoading() async {
    // var profileCode = await storage.read(key: 'profileCode10');
    // if (profileCode != '' && profileCode != null) {
    setState(() {
      examination = new ExaminationListVertical(
        site: "VET",
        model: postDio('${examinationApi}read', {
          'skip': 0,
          //'limit': _limit,
          'reference': widget.code,
          // 'profileCode': profileCode,
        }),
        titleHome: "แบบทดสอบ",
        reference: widget.code ?? '',
        url: '${examinationApi}read',
        urlGallery: examinationGalleryApi,
        callBack: () => {_onLoading()},
      );
    });
    // }

    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
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
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () => {Navigator.pop(context)},
          child: Icon(Icons.close),
          backgroundColor: Color(0xFF1B6CA8),
        ),
        body: FutureBuilder<dynamic>(
          future: _futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return myContent(snapshot.data[0]);
            } else {
              if (widget.model != null) {
                return myContent(widget.model);
              } else {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        // overflow: Overflow.visible,
                        children: [
                          Stack(
                            children: [
                              Container(height: 540, width: double.infinity),
                              Container(
                                height: 540,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: 60.0),
                              Container(
                                height: 110,
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.white,
                                        fontFamily: 'Kanit',
                                      ),
                                      maxLines: 2,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontFamily: 'Kanit',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                width: 400.0,
                                padding: EdgeInsets.only(
                                  left: 90.0,
                                  right: 90.0,
                                ),
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                  child: Container(
                                    alignment: Alignment(1, 1),
                                    child: MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      onPressed: () {},
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                            child: new Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Image.asset(
                                                'assets/logo/icons/Group337.png',
                                                height: 5.0,
                                                width: 5.0,
                                              ),
                                            ),
                                            width: 35.0,
                                            height: 35.0,
                                          ),
                                          Text(
                                            'อ่าน',
                                            style: TextStyle(
                                              color: Color(0xFF1B6CA8),
                                              fontFamily: 'Kanit',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 50.0),
                    ],
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  myContent(dynamic model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            // overflow: Overflow.visible,
            children: [
              Stack(
                children: [
                  Container(
                    height: 540,
                    width: double.infinity,
                    child: Image.network(model['imageUrl'], fit: BoxFit.cover),
                  ),
                  Container(height: 540, color: Colors.black.withOpacity(0.5)),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 60.0),
                  loadingImageNetwork(
                    model['imageUrl'],
                    fit: BoxFit.cover,
                    height: 334,
                    width: 250,
                  ),
                  // Image.network(model['imageUrl'], height: 334, width: 250),
                  Container(
                    height: 110,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                      top: 10.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          model['title'],
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          dateStringToDate(model['createDate']),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: 400.0,
                    padding: EdgeInsets.only(left: 90.0, right: 90.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: Container(
                        alignment: Alignment(1, 1),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            launchURL(model['fileUrl']);
                            // launchInWebViewWithJavaScript(model['fileUrl']);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PdfViewerPage(
                            //       path: model['fileUrl'],
                            //     ),
                            //   ),
                            // );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                child: new Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Image.asset(
                                    'assets/logo/icons/Group337.png',
                                    height: 5.0,
                                    width: 5.0,
                                    color: Color(0xFF1B6CA8),
                                  ),
                                ),
                                width: 35.0,
                                height: 35.0,
                              ),
                              Text(
                                'อ่าน',
                                style: TextStyle(
                                  color: Color(0xFF1B6CA8),
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Column(
            children: [
              TextDetail(
                title: 'ข้อมูล',
                value: '',
                fsTitle: 18.0,
                fsValue: 13.0,
                color: Colors.black,
              ),
              model['author'] != ''
                  ? TextDetail(
                    title: 'ผู้แต่ง',
                    value: '${model['author']}',
                    fsTitle: 13.0,
                    fsValue: 13.0,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w900,
                  )
                  : Container(),
              model['publisher'] != ''
                  ? TextDetail(
                    title: 'สำนักพิมพ์',
                    value: '${model['publisher']}',
                    fsTitle: 13.0,
                    fsValue: 13.0,
                    color: Color(0xFF000000),
                  )
                  : Container(),
              model['categoryList'][0]['title'] != ''
                  ? TextDetail(
                    title: 'หมวดหมู่',
                    value: '${model['categoryList'][0]['title']}',
                    fsTitle: 13.0,
                    fsValue: 13.0,
                    color: Color(0xFF000000),
                  )
                  : Container(),
              model['bookType'] != ''
                  ? TextDetail(
                    title: 'ประเภทหนังสือ',
                    value: '${model['bookType']}',
                    fsTitle: 13.0,
                    fsValue: 13.0,
                    color: Color(0xFF000000),
                  )
                  : Container(),
              model['numberOfPages'] != ''
                  ? TextDetail(
                    title: 'จำนวนหน้า',
                    value: '${model['numberOfPages'].toString()}',
                    fsTitle: 13.0,
                    fsValue: 13.0,
                    color: Color(0xFF000000),
                  )
                  : Container(),
              model['size'] != ''
                  ? TextDetail(
                    title: 'ขนาด',
                    value: '${model['size'].toString()}',
                    fsTitle: 13.0,
                    fsValue: 13.0,
                    color: Color(0xFF000000),
                  )
                  : Container(),
              SizedBox(height: 20.0),
              TextDetail(
                title: 'รายละเอียด',
                value: '',
                fsTitle: 18.0,
                fsValue: 13.0,
                color: Colors.black,
              ),
              SizedBox(height: 10.0),
              Container(
                width: 380,
                padding: EdgeInsets.only(left: 10.0, top: 5, right: 10.0),
                alignment: Alignment.topLeft,
                child: Html(
                  data: model['description'],
                  onLinkTap: (
                    String? url,
                    Map<String, String> attributes,
                    element,
                  ) {
                    launchInWebViewWithJavaScript(url!);
                    //open URL in webview, or launch URL in browser, or any other logic here
                  },
                ),
              ),
              SizedBox(height: 40.0),
              model['linkUrl'] != '' && model['textButton'] != ''
                  ? linkButton(model)
                  : Container(),
              SizedBox(height: 20.0),
              TextDetail(
                title: 'แบบทดสอบ',
                value: '',
                fsTitle: 18.0,
                fsValue: 13.0,
                color: Colors.black,
              ),

              ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                // controller: _controller,
                children: [examination ?? Container()],
              ),
              // Expanded(
              //   child: SmartRefresher(
              //     enablePullDown: false,
              //     enablePullUp: true,
              //     footer: ClassicFooter(
              //       loadingText: ' ',
              //       canLoadingText: ' ',
              //       idleText: ' ',
              //       idleIcon: Icon(
              //         Icons.arrow_upward,
              //         color: Colors.transparent,
              //       ),
              //     ),
              //     controller: _refreshController,
              //     onLoading: _onLoading,
              //     child: ListView(
              //       physics: ScrollPhysics(),
              //       shrinkWrap: true,
              //       // controller: _controller,
              //       children: [examination],
              //     ),
              //   ),
              // ),
              SizedBox(height: 40.0),
            ],
          ),
        ],
      ),
    );
  }

  linkButton(dynamic model) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 45.0,
      padding: EdgeInsets.symmetric(horizontal: 80.0),
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Color(0xFF1B6CA8)),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchURL('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: TextStyle(color: Color(0xFF1B6CA8), fontFamily: 'Kanit'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class TextDetail extends StatelessWidget {
  TextDetail({
    Key? key,
    this.title,
    this.value,
    this.fsTitle,
    this.fsValue,
    this.color,
    this.fontWeight,
  });

  final String? title;
  final String? value;
  final double? fsTitle;
  final double? fsValue;
  final Color? color;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 140,
          padding: EdgeInsets.only(left: 10.0, top: 5, right: 10.0),
          alignment: Alignment.topLeft,
          child: Text(
            title ?? '',
            style: TextStyle(
              fontSize: fsTitle,
              color: color,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10.0, top: 5),
            child: Text(
              value ?? '',
              style: TextStyle(
                fontSize: fsValue,
                color: color,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.w300,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
