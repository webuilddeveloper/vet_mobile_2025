import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:vet/shared/api_provider.dart';

class ContactListVertical extends StatefulWidget {
  ContactListVertical({
    Key? key,
    this.site,
    this.model,
    this.title,
    this.url,
  }) : super(key: key);

  final String? site;
  final Future<dynamic>? model;
  final String? title;
  final String? url;

  @override
  _ContactListVertical createState() => _ContactListVertical();
}

class _ContactListVertical extends State<ContactListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  _makePhoneCall(String url) async {
    // final Uri launchUri = Uri(
    //   scheme: 'tel',
    //   path: url,
    // );
    await launch("tel://$url");
    // if (await canLaunch(url)) {
    //   await launchUrl(launchUri);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Container(
              color: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 80.0,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          color: Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1, color: Color(0xFF1B6CA8)),
                              ),
                              child: Image.network(
                                  '${snapshot.data[index]['imageUrl']}'),
                              width: 50.0,
                              height: 50.0,
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${snapshot.data[index]['phone']}',
                                    style: TextStyle(
                                        // fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        color: Color(0xFF1B6CA8)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${snapshot.data[index]['title']}',
                                    style: TextStyle(
                                      // fontWeight: FontWeight.normal,
                                      fontSize: 12.0,
                                      fontFamily: 'Kanit',
                                      color: Color.fromRGBO(0, 0, 0, 0.6),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: 50,
                              child: InkWell(
                                onTap: () async {
                                  var phone = snapshot.data[index]['phone'];
                                  _callReport(snapshot.data[index]);

                                  List<String> phoneList = phone.split(',');
                                  if (phoneList.length > 1) {
                                    _modalChooseNumber(phoneList,
                                        snapshot.data[index]['title']);
                                  } else {
                                    _makePhoneCall(phone);
                                  }
                                },
                                child: Container(
                                  width: 50.00,
                                  height: 50.00,
                                  padding: EdgeInsets.all(10.00),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27),
                                    color: Color(0xFFA12624),
                                  ),
                                  child: Image.asset('assets/images/phone.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                },
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }

  _callReport(dynamic model) {
    postDio('${contactApi}read', {'code': model['code']});
  }

  _modalChooseNumber(dynamic model, title) {
    return showCupertinoModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Material(
            type: MaterialType.transparency,
            child: new Container(
              height: MediaQuery.of(context).size.height * 0.4 + 70,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: double.infinity,
                            child: Text(
                              title,
                              style: TextStyle(
                                fontFamily: 'Kanit',
                                fontSize: 16,
                                color: Color(0xFF000000),
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFFD4D1E),
                            ),
                            child: Icon(
                              Icons.clear,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.separated(
                    itemCount: model.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 80.0,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.circular(10.0),
                          color: Color(0xFFFFFFFF),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${model[index]}',
                                    style: TextStyle(
                                        // fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        fontFamily: 'Kanit',
                                        color: Color(0xFF1B6CA8)),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            Container(
                              width: 50,
                              child: InkWell(
                                onTap: () {
                                  _makePhoneCall(model[index]);
                                },
                                child: Container(
                                  width: 50.00,
                                  height: 50.00,
                                  padding: EdgeInsets.all(10.00),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(27),
                                    color: Color(0xFFA12624),
                                  ),
                                  child: Image.asset('assets/images/phone.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
