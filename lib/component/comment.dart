import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vet/component/comment_loading.dart';
import 'package:vet/pages/blank_page/toast_fail.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/shared/extension.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  Comment({Key? key, this.code, this.url, this.model, this.limit})
    : super(key: key);

  final String? code;
  final String? url;
  Future<dynamic>? model;
  final int? limit;

  @override
  _Comment createState() => _Comment();
}

class _Comment extends State<Comment> {
  final txtDescription = TextEditingController();
  FlutterSecureStorage? storage;
  String username = '';
  String imageUrlCreateBy = '';
  bool hideDialog = true;
  String profileCode = '';

  // Future<dynamic> _futureModel;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    storage = FlutterSecureStorage();

    getUser();
    super.initState();
  }

  setDelayShowDialog() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        hideDialog = true;
        // Here you can write your code for open new view
      });
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: new Text(
                'ขอบคุณสำหรับความคิดเห็น',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: new Text(
                    "ยกเลิก",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Theme.of(context).primaryColorDark,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }

  getUser() async {
    var profile = await storage?.read(key: 'profileCode9');
    var value = await storage?.read(key: 'dataUserLoginDDPM');
    var data = json.decode(value!);

    setState(() {
      profileCode = profile!;
      imageUrlCreateBy = data['imageUrl'];
      username = data['firstName'] + ' ' + data['lastName'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            'แสดงความคิดเห็น',
            style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextField(
            controller: txtDescription,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 100,
            style: TextStyle(fontSize: 13, fontFamily: 'Kanit'),
            // decoration: new InputDecoration(hintText: "Enter Something", contentPadding: const EdgeInsets.all(20.0)),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withAlpha(50),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                gapPadding: 1,
              ),
              hintText: 'แสดงความคิดเห็น',
              contentPadding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Theme.of(context).primaryColorDark, // ✅ เปลี่ยนตรงนี้
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text(
              'ส่ง',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Kanit',
              ),
            ),
            onPressed: () {
              sendComment();
            },
          ),
        ),

        FutureBuilder<dynamic>(
          // future: widget.model,
          future: widget.model,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return myComment(snapshot.data);
            } else {
              return CommentLoading();
              // return Container();
            }

            // if (snapshot.hasError) {
            //   return Text(snapshot.error.toString());
            // }

            // return Container(
            //   alignment: Alignment.center,
            //   height: 200,
            //   child: Text('Loading...'),
            // );
          },
        ),
      ],
    );
  }

  myComment(dynamic model) {
    return Container(
      // color: Colors.red,
      child: ListView.builder(
        shrinkWrap: true, // 1st add
        physics: ClampingScrollPhysics(), // 2nd
        // scrollDirection: Axis.horizontal,
        itemCount: model.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFFCFDAE3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(
                    '${model[index]['imageUrlCreateBy']}' != '' ? 0.0 : 5.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(17.5),
                    color: Colors.black12,
                  ),
                  width: 35.0,
                  height: 35.0,
                  child:
                      '${model[index]['imageUrlCreateBy']}' != ''
                          ? CircleAvatar(
                            backgroundImage:
                                model[index]['imageUrlCreateBy'] != null
                                    ? NetworkImage(
                                      '${model[index]['imageUrlCreateBy']}',
                                    )
                                    : null,
                          )
                          : Image.asset(
                            'assets/images/user_not_found.png',
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model[index]['createBy']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          fontFamily: 'Kanit',
                          color: Color(0xFF99722F),
                        ),
                      ),
                      Text(
                        '${model[index]['description']}',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Kanit',
                          color: Color(0xFF99722F),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    // dateStringToDate(model[index]['createDate']),
                    differenceCurrentDate(model[index]['createDate']),
                    // dateStringToDate(model[index]['createDate']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      color: Colors.black.withAlpha(80),
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  sendComment() async {
    if (txtDescription.text != '') {
      postAny('${widget.url}create', {
            'createBy': username,
            'imageUrlCreateBy': imageUrlCreateBy,
            'reference': widget.code,
            'description': txtDescription.text,
            'profileCode': profileCode,
          })
          .then((response) {
            if (response == 'S') {
              txtDescription.text = '';

              unfocus(context);

              setState(() {
                widget.model = post('${widget.url}read', {
                  'skip': 0,
                  'limit': widget.limit,
                  'code': widget.code,
                });
              });
              // helloWorld();
              toastFail(
                context: context,
                text: 'ขอบคุณสำหรับความคิดเห็น',
                duration: 4,
              );
            } else {
              return showDialog(
                context: context,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () {
                      return Future.value(false);
                    },
                    child: CupertinoAlertDialog(
                      title: new Text(
                        'ไม่สามารถแสดงความคิดเห็นได้',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Kanit',
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      content: Text(" "),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: new Text(
                            "ตกลง",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Kanit',
                              color: Theme.of(context).primaryColorDark,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          })
          .catchError((onError) {
            return showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () {
                    return Future.value(false);
                  },
                  child: CupertinoAlertDialog(
                    title: new Text(
                      'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kanit',
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    content: Text(" "),
                    actions: [
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        child: new Text(
                          "ตกลง",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Kanit',
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          });
    }
  }
}
