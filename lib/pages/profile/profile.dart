import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:vet/pages/blank_page/blank_loading.dart';
import 'package:vet/pages/profile/identity_verification.dart';


class Profile extends StatefulWidget {
  Profile({Key? key, this.model, this.organizationImage, this.nav, this.nav1})
      : super(key: key);

  final Future<dynamic>? model;
  final Future<dynamic>? organizationImage;
  final Function? nav;
  final Function? nav1;

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final storage = new FlutterSecureStorage();

  late String _profileCode;

  @override
  void initState() {
    _callInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _buildCard(model: snapshot.data);
        } else if (snapshot.hasError) {
          return _buildCard(model: {
            'imageUrl': '',
            'firstName': 'การเชื่อมต่อขัดข้อง',
            'lastName': ''
          });
        } else {
          return _buildCard(
              model: {'imageUrl': '', 'firstName': '', 'lastName': ''});
        }
      },
    );
  }

  _buildCard({dynamic model}) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(15.0),

        // border: Border.all(color: Colors.white),
        gradient: LinearGradient(
            colors: model['vetCategory'] != '' && model['vetCategory'] != null
                ? model['vetCategory'] == 'ทั่วไป'
                    ? [
                        Color(0xFFCCCCCC),
                        Color(0xFF707070),
                      ]
                    : model['vetCategory'] == 'ชั้นหนึ่ง' ||
                            model['vetCategory'] == 'ชั้นหนึ่ง'
                        ? [
                            Color(0xFF33B1C4),
                            Color(0xFF1B6CA8),
                          ]
                        : [
                            Color(0xFFE19B24),
                            Color(0xFFA36910),
                          ]
                : [
                    Color(0xFFCCCCCC),
                    Color(0xFF707070),
                  ]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.all('${model['imageUrl']}' != '' ? 0.0 : 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width * 9 / 100),
                    color: Color(0xFF1B6CA8),
                  ),
                  height: width * 18 / 100,
                  width: width * 18 / 100,
                  child: GestureDetector(
                    onTap: () => widget.nav!(),
                    child: model['imageUrl'] != '' && model['imageUrl'] != null
                        ? CircleAvatar(
                            backgroundColor: Colors.black,
                            backgroundImage: model['imageUrl'] != null
                                ? NetworkImage(model['imageUrl'])
                                : null,
                          )
                        : Container(
                            padding: EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/images/user_not_found.png',
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.nav!(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.only(
                        //     left: 375 * 3 / 100,
                        //     right: 375 * 1 / 100,
                        //   ),
                        //   child: Text(
                        //     'อาสากู้ภัย',
                        //     style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: 18.0,
                        //       fontWeight: FontWeight.bold,
                        //       fontFamily: 'Kanit',
                        //     ),
                        //     maxLines: 1,
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 5.0,
                          ),
                          child: Text(
                            '${model['firstName']} ${model['lastName']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Kanit',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                            left: 10.0,
                          ),
                          child: _buildOrganizationImage(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () => widget.nav!(),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(8),
                        color: model['vetCategory'] != '' &&
                                model['vetCategory'] != null
                            ? model['vetCategory'] == 'ทั่วไป'
                                ? Color(0xFFB5B5B5)
                                : model['vetCategory'] == 'ชั้นนหนึ่ง' ||
                                        model['vetCategory'] == 'ชั้นหนึ่ง'
                                    ? Color(0xFF33B1C4)
                                    : Color(0xFFE19B24)
                            : Color(0xFFB5B5B5)),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.only(right: 10.0),
                    width: 30,
                    height: 30,
                    child: Image.asset(
                      "assets/logo/icons/right.png",
                      color: Colors.white,
                      height: 10,
                      width: 10,
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  padding: EdgeInsets.only(top: 40),
                  alignment: Alignment.center,
                  child: Text(
                    model["reNewTo"] != "" && model["reNewTo"] != null
                        ? 'Expired ' + model["reNewTo"]
                        : '',
                    style: TextStyle(
                      color: model["isExpireDate"] != "" &&
                              model["isExpireDate"] != null
                          ? model["isExpireDate"] == "1"
                              ? Colors.red
                              : Colors.white
                          : Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     alignment: Alignment.center,
          //     // height: 50,
          //     // width: width * 8 / 100,
          //     child: InkWell(
          //       onTap: () => widget.nav1(),
          //       child: Image.asset(
          //         'assets/logo/icons/Group313.png',
          //         height: 20,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  _buildOrganizationImage() {
    return FutureBuilder<dynamic>(
      //future: widget.organizationImage, // function where you call your api
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        // data from refresh api
        if (snapshot.hasData) {
          //print('--------667--------${snapshot.data}');
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(right: 10, bottom: 5.0),
                  child: snapshot.data['vetCategory'] == '' ||
                          snapshot.data['vetCategory'] == null
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => IdentityVerificationPage(
                                  title: 'ยืนยันตัวตน',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Text(
                              'รอยืนยันตัวตน',
                              style: TextStyle(
                                color: Color(0xFF707070),
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Kanit',
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      : Text(
                          snapshot.data['vetCategory'] == 'ทั่วไป'
                              ? 'บุคคลทั่วไป'
                              : 'สัตวแพทย์' + snapshot.data['vetCategory'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                ),
              ),
            ],
          );
        } else if (snapshot.hasError) {
          // goLogin();
          return BlankLoading();
        } else {
          return BlankLoading();
        }
      },
    );
  }

  _callInit() async {
    var profileCode = await storage.read(key: 'profileCode9');
    if (profileCode != '' && profileCode != null)
      setState(() {
        _profileCode = profileCode;
      });
  }
}
