import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vet/component/carousel_form.dart';
import 'package:vet/component/carousel_rotation.dart';
import 'package:vet/component/gallery_view.dart';
import 'package:vet/component/link_url_in.dart';
import 'package:vet/component/link_url_out.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/shared/extension.dart';

// ignore: must_be_immutable
class ContentEventCalendar extends StatefulWidget {
  ContentEventCalendar({
    Key? key,
    this.code,
    this.url,
    this.model,
    this.urlGallery,
    this.urlRotation,
    this.pathShare,
  }) : super(key: key);

  final String? code;
  final String? url;
  final dynamic? model;
  final String? urlGallery;
  final String? urlRotation;
  final String? pathShare;

  @override
  _ContentEventCalendar createState() => _ContentEventCalendar();
}

class _ContentEventCalendar extends State<ContentEventCalendar> {
  Future<dynamic>? _futureModel;
  Future<dynamic>? _futureRotation;
  final storage = new FlutterSecureStorage();

  String _urlShared = '';
  List urlImage = [];
  List<ImageProvider> urlImageProvider = [];

  @override
  void initState() {
    super.initState();
    initFunc();
    sharedApi();

    readGallery();
  }

  initFunc() async {
    _futureModel = postDio(widget.url ?? '', {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
    _futureRotation = postDio(widget.urlRotation ?? '', {'limit': 10});
  }

  Future<dynamic> readGallery() async {
    final result = await postDio(widget.urlGallery ?? '', {
      'code': widget.code,
    });

    List data = [];
    List<ImageProvider> dataPro = [];

    for (var item in result) {
      data.add(item['imageUrl']);

      dataPro.add(
        item['imageUrl'] != null
            ? NetworkImage(item['imageUrl'])
            : AssetImage('assets/images/default_image.png'),
      );
    }

    setState(() {
      urlImage = data;
      urlImageProvider = dataPro;
    });
  }

  Future<dynamic> sharedApi() async {
    await postConfigShare().then(
      (result) => {
        if (result['status'] == 'S')
          {
            setState(() {
              _urlShared = result['objectData']['description'];
            }),
          },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _futureModel, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          // setState(() {
          //   urlImage = [snapshot.data[0].imageUrl];
          // });
          return myContent(
            snapshot.data[0],
          ); //   return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return myContent(widget.model);
          // return myContent(widget.model);
        }
      },
    );
  }

  myContent(dynamic model) {
    List image = ['${model['imageUrl']}'];

    List<ImageProvider> imagePro = [];
    if (model['imageUrl'] != null) {
      imagePro.add(NetworkImage(model['imageUrl']));
    }
    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      children: [
        Container(
          // width: 500.0,
          // color: Color(0xFFFFFFF),
          color: Colors.white,
          child: GalleryView(
            imageUrl: [...image, ...urlImage],
            imageProvider: [...imagePro, ...urlImageProvider],
          ),
        ),
        Container(
          // color: Colors.green,
          padding: EdgeInsets.only(right: 10.0, left: 10.0),
          margin: EdgeInsets.only(right: 50.0, top: 10.0),
          child: Text(
            '${model['title']}',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Kanit',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
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
                              model['createDate'] != null
                                  ? dateThai(model['createDate']) + ' | '
                                  : '',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              'เข้าชม ' + '${model['view']}' + ' ครั้ง',
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(
                            (model['dateStart'] != '' &&
                                        model['dateStart'] != 'Invalid date') &&
                                    (model['dateEnd'] != '' &&
                                        model['dateEnd'] != 'Invalid date')
                                ? 'วันที่จัดกิจกรรม: ' +
                                    dateThai(model['dateStart']) +
                                    " - " +
                                    dateThai(model['dateEnd'])
                                : 'วันที่จัดกิจกรรม: -',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontFamily: 'Kanit',
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.24,
                    child: Container(
                      width: 100.0,
                      height: 35.0,
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          final box = context.findRenderObject() as RenderBox?;
                          if (box != null) {
                            Share.share(
                              _urlShared +
                                  (widget.pathShare ?? '') +
                                  '${model['code'] ?? ''}' +
                                  ' ${model['title'] ?? ''}',
                              subject: model['title'] ?? '',
                              sharePositionOrigin:
                                  box.localToGlobal(Offset.zero) & box.size,
                            );
                          }
                        },
                        child: Image.asset('assets/images/share.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   width: 74.0,
            //   height: 31.0,
            //   // decoration: BoxDecoration(
            //   //     image: DecorationImage(
            //   //       image: AssetImage('assets/images/share.png'),
            //   //     )),
            //   alignment: Alignment.centerRight,
            //   child: FlatButton(
            //     padding: EdgeInsets.all(0.0),
            //     onPressed: () {
            //       final RenderBox box = context.findRenderObject();
            //       Share.share(
            //         _urlShared +
            //             widget.pathShare +
            //             '${model['code']}' +
            //             ' ${model['title']}',
            //         subject: '${model['title']}',
            //         sharePositionOrigin:
            //             box.localToGlobal(Offset.zero) & box.size,
            //       );
            //     },
            //     child: Image.asset('assets/images/share.png'),
            //   ),
            // )
          ],
        ),
        Container(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
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
        Container(height: 10),
        model['linkUrl'] != '' && model['textButton'] != ''
            ? linkButton(model)
            : Container(),
        Container(height: 10),
        model['fileUrl'] != '' ? fileUrl(model) : Container(),
        SizedBox(height: 10),
        if (widget.urlRotation != '') _buildRotation(),
      ],
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
            border: Border.all(color: Color(0xFF99722F)),
          ),
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              launchURL('${model['linkUrl']}');
            },
            child: Text(
              '${model['textButton']}',
              style: TextStyle(color: Color(0xFF99722F), fontFamily: 'Kanit'),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }

  fileUrl(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      alignment: Alignment.center,
      child: InkWell(
        onTap: () {
          launchURL('${model['fileUrl']}');
        },
        child: Text(
          'เปิดเอกสารแนบ',
          style: TextStyle(
            fontFamily: 'Kanit',
            fontSize: 14.0,
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  _buildRotation() {
    return Container(
      // padding: EdgeInsets.only(left: 15, right: 15, top: 5),
      child: CarouselRotation(
        model: _futureRotation,
        nav: (String path, String action, dynamic model, String code) {
          if (action == 'out') {
            launchInWebViewWithJavaScript(path);
            // launchURL(path);
          } else if (action == 'in') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CarouselForm(
                      code: code,
                      model: model,
                      url: mainBannerApi,
                      urlGallery: bannerGalleryApi,
                    ),
              ),
            );
          }
        },
      ),
    );
  }
}
