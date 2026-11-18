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
          return _buildCard(
            model: {
              'imageUrl': '',
              'firstName': 'การเชื่อมต่อขัดข้อง',
              'lastName': '',
            },
          );
        } else {
          return _buildCard(
            model: {'imageUrl': '', 'firstName': '', 'lastName': ''},
          );
        }
      },
    );
  }

  // ===== ใส่ไว้ใน State class =====

  /// รวมสีตามประเภท จะได้ไม่ต้องเขียนเงื่อนไขซ้ำหลายที่
  ({List<Color> gradient, Color accent}) _categoryStyle(dynamic category) {
    switch (category) {
      case 'ชั้นหนึ่ง':
      case 'ชั้นนหนึ่ง': // กันข้อมูลที่พิมพ์ผิดจาก backend
        return (
          gradient: const [Color(0xFF33B1C4), Color(0xFF1B6CA8)],
          accent: const Color(0xFF33B1C4),
        );
      case 'ทั่วไป':
      case null:
      case '':
        return (
          gradient: const [Color(0xFFCCCCCC), Color(0xFF707070)],
          accent: const Color(0xFFB5B5B5),
        );
      default:
        return (
          gradient: const [Color(0xFFE19B24), Color(0xFFA36910)],
          accent: const Color(0xFFE19B24),
        );
    }
  }

  Widget _buildCard({required dynamic model}) {
    final width = MediaQuery.of(context).size.width;
    final avatarSize = (width * 0.18).clamp(56.0, 80.0);
    final style = _categoryStyle(model['vetCategory']);

    final hasImage = model['imageUrl'] != null && model['imageUrl'] != '';
    final hasExpire = model['reNewTo'] != null && model['reNewTo'] != '';
    final isExpired = model['isExpireDate'] == '1';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: style.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: style.gradient.last.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // วงกลมตกแต่งพื้นหลัง
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            if (!MediaQuery.disableAnimationsOf(context))
              const Positioned.fill(child: IgnorePointer(child: _CardSheen())),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => widget.nav?.call(),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // รูปโปรไฟล์
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: Container(
                          width: avatarSize,
                          height: avatarSize,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF1B6CA8),
                          ),
                          child:
                              hasImage
                                  ? CircleAvatar(
                                    backgroundColor: Colors.black12,
                                    backgroundImage: NetworkImage(
                                      model['imageUrl'],
                                    ),
                                  )
                                  : Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/images/user_not_found.png',
                                      color:
                                          Theme.of(context).primaryColorLight,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // ชื่อ + หน่วยงาน
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${model['firstName']} ${model['lastName']}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Kanit',
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildOrganizationImage(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // ลูกศร + วันหมดอายุ
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.25),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            padding: const EdgeInsets.all(9),
                            child: Image.asset(
                              'assets/logo/icons/right.png',
                              color: Colors.white,
                            ),
                          ),
                          if (hasExpire) ...[
                            const SizedBox(height: 24),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    isExpired
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.22),
                              ),
                              child: Text(
                                'Exp. Date: ${model['reNewTo']}',
                                style: TextStyle(
                                  color:
                                      isExpired
                                          ? Colors.red.shade700
                                          : Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // _buildCard({dynamic model}) {
  //   double width = MediaQuery.of(context).size.width;
  //   return Container(
  //     padding: EdgeInsets.all(10.0),
  //     alignment: Alignment.center,
  //     decoration: BoxDecoration(
  //       color: Colors.amber,
  //       borderRadius: BorderRadius.circular(15.0),

  //       // border: Border.all(color: Colors.white),
  //       gradient: LinearGradient(
  //         colors:
  //             model['vetCategory'] != '' && model['vetCategory'] != null
  //                 ? model['vetCategory'] == 'ทั่วไป'
  //                     ? [Color(0xFFCCCCCC), Color(0xFF707070)]
  //                     : model['vetCategory'] == 'ชั้นหนึ่ง' ||
  //                         model['vetCategory'] == 'ชั้นหนึ่ง'
  //                     ? [Color(0xFF33B1C4), Color(0xFF1B6CA8)]
  //                     : [Color(0xFFE19B24), Color(0xFFA36910)]
  //                 : [Color(0xFFCCCCCC), Color(0xFF707070)],
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           flex: 4,
  //           child: Row(
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.all(
  //                   '${model['imageUrl']}' != '' ? 0.0 : 5.0,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(width * 9 / 100),
  //                   color: Color(0xFF1B6CA8),
  //                 ),
  //                 height: width * 18 / 100,
  //                 width: width * 18 / 100,
  //                 child: GestureDetector(
  //                   onTap: () => widget.nav!(),
  //                   child:
  //                       model['imageUrl'] != '' && model['imageUrl'] != null
  //                           ? CircleAvatar(
  //                             backgroundColor: Colors.black,
  //                             backgroundImage:
  //                                 model['imageUrl'] != null
  //                                     ? NetworkImage(model['imageUrl'])
  //                                     : null,
  //                           )
  //                           : Container(
  //                             padding: EdgeInsets.all(10.0),
  //                             child: Image.asset(
  //                               'assets/images/user_not_found.png',
  //                               color: Theme.of(context).primaryColorLight,
  //                             ),
  //                           ),
  //                 ),
  //               ),
  //               Expanded(
  //                 child: GestureDetector(
  //                   onTap: () => widget.nav!(),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     mainAxisSize: MainAxisSize.max,
  //                     children: [
  //                       // Container(
  //                       //   padding: EdgeInsets.only(
  //                       //     left: 375 * 3 / 100,
  //                       //     right: 375 * 1 / 100,
  //                       //   ),
  //                       //   child: Text(
  //                       //     'อาสากู้ภัย',
  //                       //     style: TextStyle(
  //                       //       color: Colors.white,
  //                       //       fontSize: 18.0,
  //                       //       fontWeight: FontWeight.bold,
  //                       //       fontFamily: 'Kanit',
  //                       //     ),
  //                       //     maxLines: 1,
  //                       //     overflow: TextOverflow.ellipsis,
  //                       //   ),
  //                       // ),
  //                       Container(
  //                         padding: EdgeInsets.only(
  //                           left: 10,
  //                           right: 10,
  //                           bottom: 5.0,
  //                         ),
  //                         child: Text(
  //                           '${model['firstName']} ${model['lastName']}',
  //                           style: TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 15.0,
  //                             fontWeight: FontWeight.w500,
  //                             fontFamily: 'Kanit',
  //                           ),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       Container(
  //                         padding: EdgeInsets.only(left: 10.0),
  //                         child: _buildOrganizationImage(),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.end,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             mainAxisSize: MainAxisSize.max,
  //             children: [
  //               InkWell(
  //                 onTap: () => widget.nav!(),
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     borderRadius: new BorderRadius.circular(8),
  //                     color:
  //                         model['vetCategory'] != '' &&
  //                                 model['vetCategory'] != null
  //                             ? model['vetCategory'] == 'ทั่วไป'
  //                                 ? Color(0xFFB5B5B5)
  //                                 : model['vetCategory'] == 'ชั้นนหนึ่ง' ||
  //                                     model['vetCategory'] == 'ชั้นหนึ่ง'
  //                                 ? Color(0xFF33B1C4)
  //                                 : Color(0xFFE19B24)
  //                             : Color(0xFFB5B5B5),
  //                   ),
  //                   padding: EdgeInsets.all(8.0),
  //                   margin: EdgeInsets.only(right: 10.0),
  //                   width: 30,
  //                   height: 30,
  //                   child: Image.asset(
  //                     "assets/logo/icons/right.png",
  //                     color: Colors.white,
  //                     height: 10,
  //                     width: 10,
  //                   ),
  //                 ),
  //               ),
  //               Container(
  //                 width: 110,
  //                 padding: EdgeInsets.only(top: 40),
  //                 alignment: Alignment.center,
  //                 child: Text(
  //                   model["reNewTo"] != "" && model["reNewTo"] != null
  //                       ? 'Exp. Date ' + model["reNewTo"]
  //                       : '',
  //                   style: TextStyle(
  //                     color:
  //                         model["isExpireDate"] != "" &&
  //                                 model["isExpireDate"] != null
  //                             ? model["isExpireDate"] == "1"
  //                                 ? Colors.red
  //                                 : Colors.white
  //                             : Colors.white,
  //                     fontSize: 12,
  //                     fontWeight: FontWeight.w500,
  //                     fontFamily: 'Kanit',
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         // Expanded(
  //         //   flex: 1,
  //         //   child: Container(
  //         //     alignment: Alignment.center,
  //         //     // height: 50,
  //         //     // width: width * 8 / 100,
  //         //     child: InkWell(
  //         //       onTap: () => widget.nav1(),
  //         //       child: Image.asset(
  //         //         'assets/logo/icons/Group313.png',
  //         //         height: 20,
  //         //       ),
  //         //     ),
  //         //   ),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

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
                  child:
                      snapshot.data['vetCategory'] == '' ||
                              snapshot.data['vetCategory'] == null
                          ? InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => IdentityVerificationPage(
                                        title: 'ยืนยันตัวตน',
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
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
    var profileCode = await storage.read(key: 'profileCode10');
    if (profileCode != '' && profileCode != null)
      setState(() {
        _profileCode = profileCode;
      });
  }
}

class _CardSheen extends StatefulWidget {
  const _CardSheen();

  @override
  State<_CardSheen> createState() => _CardSheenState();
}

class _CardSheenState extends State<_CardSheen>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 4600),
  )..repeat();

  late final _position = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: const Offset(1, 0),
  ).chain(CurveTween(curve: const Interval(0, 0.9))).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _position,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.8, -1),
            end: Alignment(0.8, 1),
            colors: [Colors.transparent, Color(0x38FFFFFF), Colors.transparent],
            stops: [0.36, 0.5, 0.64],
          ),
        ),
      ),
    );
  }
}
