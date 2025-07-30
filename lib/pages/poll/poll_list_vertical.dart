import 'package:flutter/material.dart';
import 'package:vet/pages/blank_page/blank_data.dart';
import 'package:vet/pages/blank_page/toast_fail.dart';
import 'package:vet/pages/poll/poll_form.dart';
import 'package:vet/shared/extension.dart';

class PollListVertical extends StatefulWidget {
  PollListVertical({
    Key? key,
    this.site,
    this.model,
    this.title,
    this.url,
    this.urlComment,
    this.urlGallery,
    this.titleHome,
    this.callBack,
  }) : super(key: key);

  final String? site;
  final Future<dynamic>? model;
  final String? title;
  final String? url;
  final String? urlComment;
  final String? urlGallery;
  final String? titleHome;
  final Function? callBack;

  @override
  _PollListVertical createState() => _PollListVertical();
}

class _PollListVertical extends State<PollListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items = List<String>.generate(
    10,
    (index) => "Item: ${++index}",
  );

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      snapshot.data[index]['status2']
                          ? toastFail(
                            context: context,
                            text: 'คุณตอบแบบสอบถามนี้แล้ว',
                          )
                          : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => PollForm(
                                    code: snapshot.data[index]['code'],
                                    model: snapshot.data[index],
                                    titleMenu: widget.title,
                                    titleHome: widget.titleHome,
                                    url: widget.url,
                                  ),
                            ),
                          );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Column(children: [
                        //   Container(
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(5),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: Colors.grey.withOpacity(0.5),
                        //           spreadRadius: 0,
                        //           blurRadius: 7,
                        //           offset: Offset(
                        //               0, 3), // changes position of shadow
                        //         ),
                        //       ],
                        //     ),
                        //   )
                        // ]),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                snapshot.data[index]['status2']
                                    ? Colors.grey[300]
                                    : Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset: Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          width: double.infinity,
                          // height: 160,
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.network(
                                        '${snapshot.data[index]['imageUrl']}',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 120,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${snapshot.data[index]['title']}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'Kanit',
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    padding: EdgeInsets.all(3),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            100,
                                                          ),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xFF33B1C4),
                                                          Color(0xFF1B6CA8),
                                                        ],
                                                      ),
                                                    ),
                                                    child: Image.network(
                                                      '${snapshot.data[index]['imageUrlCreateBy']}',
                                                      // fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${snapshot.data[index]['createBy']}',
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            fontFamily: 'Kanit',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                          maxLines: 3,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '${snapshot.data[index]['createDate']}' !=
                                                                      null
                                                                  ? 'วันที่ ' +
                                                                      dateStringToDate(
                                                                        '${snapshot.data[index]['createDate']}',
                                                                      )
                                                                  : '',
                                                              style: TextStyle(
                                                                fontSize: 8,
                                                                fontFamily:
                                                                    'Kanit',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Container(
                                color: Color(0xFF707070).withOpacity(0.5),
                                height: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        } else {
          return blankListData(context);
        }
      },
    );
  }
}
