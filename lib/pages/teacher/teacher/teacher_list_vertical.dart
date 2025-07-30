import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vet/pages/blank_page/blank_data.dart';
import 'package:vet/widget/dialog.dart';
import 'package:vet/widget/image_circle.dart';


class TeacherListVertical extends StatefulWidget {
  TeacherListVertical({
    Key? key,
    this.site,
    this.model,
    this.title,
    this.url,
    this.urlComment,
    this.urlGallery,
  }) : super(key: key);

  final String? site;
  final Future<dynamic>? model;
  final String? title;
  final String? url;
  final String? urlComment;
  final String? urlGallery;

  @override
  _TeacherListVertical createState() => _TeacherListVertical();
}

class _TeacherListVertical extends State<TeacherListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  @override
  Widget build(BuildContext context) {
    // print('----- Hello -----');
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            // print('----- hasData [0] -----');
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
            // print('----- hasData [1] ----- ${snapshot.data.toString()}');
            return card(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            child: Text(
              'Network ขัดข้อง',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Kanit',
                color: Color.fromRGBO(0, 0, 0, 0.6),
              ),
            ),
          );
        } else {
          return blankListData(context);
        }
      },
    );
  }

  card(dynamic model) {
     print('----- card ----- ' + model[0].toString());
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              dialogVetProfile(
                context,
                model: model[index],
              );

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => TeacherForm(
              //       // code: model[index]['code'],
              //       model: model[index],
              //     ),
              //   ),
              // );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      margin: EdgeInsets.only(bottom: 5.0),
                      height: 100,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFFFFFF),
                              borderRadius: new BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageCircle(
                                  context,
                                  image: model[index]['photoBase64'] != null
                                      ? model[index]['photoBase64']
                                      : '',
                                  width: 80.0,
                                  height: 80.0,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // color: Colors.red,
                                      width: width * 60 / 100,
                                      margin: EdgeInsets.only(left: 8),
                                      child: Text(
                                        '${model[index]['nameTh']} ${model[index]['lastnameTh']}',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Kanit',
                                          fontSize: 15,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    // Container(
                                    //   margin: EdgeInsets.only(left: 8),
                                    //   child: Text(
                                    //     'สังกัด : ' +
                                    //         model[index]['schoolName'],
                                    //     style: TextStyle(
                                    //       color: Color(0xFF000000),
                                    //       fontFamily: 'Kanit',
                                    //       fontSize: 11,
                                    //       fontWeight: FontWeight.w400,
                                    //     ),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.greenAccent,
                                      ),
                                      child: Text(
                                        'สัตวแพทย์ ชั้น ${model[index]['category']}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Kanit',
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    )
                                    //checkCertificateTeacher(model[index]),
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
            ),
          );
        },
      ),
    );
  }
}
