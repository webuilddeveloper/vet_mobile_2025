import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vet/pages/blank_page/dialog_fail.dart';
import 'package:vet/shared/api_provider.dart';
import 'package:vet/widget/dialog.dart';


import 'splash.dart';

class VersionPage extends StatefulWidget {
  const VersionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VersionPageState createState() => _VersionPageState();
}

class _VersionPageState extends State<VersionPage> {
  Future<dynamic>? futureModel;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['isActive']) {
                if (versionNumber < snapshot.data['version']) {
                  // print('update');

                  return Center(
                    child: Container(
                      color: Colors.white,
                      child: dialogVersion(
                        context,
                        title: snapshot.data['title'],
                        description: snapshot.data['description'],
                        isYesNo: !snapshot.data['isForce'],
                        callBack: (param) {
                          if (param) {
                            launch(snapshot.data['url']);
                          } else {
                            _callGoSplash();
                          }
                        },
                      ),
                    ),
                  );
                } else {
                  _callGoSplash();
                }
              } else {
                _callGoSplash();
              }
              return Container();
            } else if (snapshot.hasError) {
              return Center(
                child: Container(
                  color: Colors.white,
                  child: dialogFail(context, reloadApp: false),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  _callRead() {
    if (Platform.isAndroid) {
      futureModel = postDio(versionReadApi, {'platform': 'Android'});
    } else if (Platform.isIOS) {
      futureModel = postDio(versionReadApi, {'platform': 'Ios'});
    }
  }

  _callGoSplash() {
    // print('go splash');

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   // Add Your Code here.
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => SplashPage(),
    //     ),
    //   );
    // });

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // add your code here.
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => SplashPage()));
    });
  }
}
