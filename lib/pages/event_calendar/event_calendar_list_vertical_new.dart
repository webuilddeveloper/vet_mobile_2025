import 'package:flutter/material.dart';
import 'package:vet/component/loading_image_network.dart';
import 'package:vet/pages/blank_page/blank_data.dart';
import 'package:vet/pages/event_calendar/event_calendar_form.dart';
import 'package:vet/shared/extension.dart';

class EventCalendarEventListVerticalNew extends StatefulWidget {
  EventCalendarEventListVerticalNew({
    Key? key,
    this.model,
    this.title,
    this.url,
    this.urlComment,
    this.urlGallery,
    this.code,
  }) : super(key: key);

  final Future<dynamic>? model;
  final String? title;
  final String? url;
  final String? urlComment;
  final String? urlGallery;
  final String? code;

  @override
  _EventCalendarEventListVerticalNew createState() =>
      _EventCalendarEventListVerticalNew();
}

class _EventCalendarEventListVerticalNew
    extends State<EventCalendarEventListVerticalNew> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              height: 200,
              alignment: Alignment.center,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventCalendarForm(
                              urlGallery: widget.urlGallery,
                              urlComment: widget.urlComment,
                              model: snapshot.data[index],
                              url: widget.url,
                              code: snapshot.data[index]['code']),
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
                            color: Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(5),
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
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                  Expanded(
                                    child: Container(
                                      height: 120,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
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
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(3),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Color(0xFF33B1C4),
                                                            Color(0xFF1B6CA8),
                                                          ],
                                                        ),
                                                      ),
                                                      child: Image.network(
                                                        '${snapshot.data[index]['imageUrlCreateBy']}',
                                                        width: 30,
                                                        height: 30,
                                                        // fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              '${snapshot.data[index]['createBy']}',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    'Kanit',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                              maxLines: 3,
                                                            ),
                                                          ),
                                                          Container(
                                                            child: Text(
                                                              (snapshot.data[index]['dateStart'] !=
                                                                              '' &&
                                                                          snapshot.data[index]['dateStart'] !=
                                                                              'Invalid date') &&
                                                                      (snapshot.data[index]['dateEnd'] !=
                                                                              '' &&
                                                                          snapshot.data[index]['dateEnd'] !=
                                                                              'Invalid date')
                                                                  ? 'วันที่จัดกิจกรรม: ' +
                                                                      dateThai(
                                                                          snapshot.data[index]
                                                                              [
                                                                              'dateStart']) +
                                                                      " - " +
                                                                      dateThai(
                                                                          snapshot.data[index]
                                                                              [
                                                                              'dateEnd'])
                                                                  : 'วันที่จัดกิจกรรม: -',
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF000000),
                                                                fontFamily:
                                                                    'Kanit',
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                            ),
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
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
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
          return blankGridData(context);
        }
      },
    );
  }

  demoItem(dynamic model) {
    return Column(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventCalendarForm(
                    urlGallery: widget.urlGallery,
                    urlComment: widget.urlComment,
                    model: model,
                    url: widget.url,
                    code: model['code'],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: new BorderRadius.circular(6.0),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: loadingImageNetwork(
                    model['imageUrl'],
                  )
                  //               Image.network(
                  //   model['imageUrl'],
                  // ),
                  ),
            ),
          ),
        ),
        Container(
          child: Center(
            child: Image.asset('assets/images/bar.png'),
          ),
        ),
      ],
    );
  }

  myCard(int index, int lastIndex, dynamic model, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarForm(
              urlGallery: widget.urlGallery,
              urlComment: widget.urlComment,
              model: model,
              url: widget.url,
              code: model['code'],
            ),
          ),
        );
      },
      child: Container(
        margin: index % 2 == 0
            ? EdgeInsets.only(bottom: 5.0, right: 5.0)
            : EdgeInsets.only(bottom: 5.0, left: 5.0),
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              Color(0xFF1B6CA8),
              Color(0xFF1B6CA8),
            ],
          ),
        ),
        child: Column(
          // alignment: Alignment.topCenter,
          children: [
            Expanded(
              child: Container(
                height: 157.0,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(5.0),
                    topRight: const Radius.circular(5.0),
                  ),
                  color: Colors.white.withAlpha(220),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(model['imageUrl']),
                  ),
                ),
              ),
            ),
            Container(
              // margin: EdgeInsets.only(top: 157.0),
              padding: EdgeInsets.all(5),
              alignment: Alignment.topLeft,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(5.0),
                  bottomRight: const Radius.circular(5.0),
                ),
                color: Colors.black.withAlpha(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      fontSize: 10,
                      color: Color(0xFFFFFFFF),
                      // color: Colors.white,
                      fontFamily: 'Kanit',
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  // Text(
                  //   dateStringToDate(model['createDate']),
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.normal,
                  //     fontSize: 8,
                  //     fontFamily: 'Kanit',
                  //     color: Colors.white,
                  //   ),
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
