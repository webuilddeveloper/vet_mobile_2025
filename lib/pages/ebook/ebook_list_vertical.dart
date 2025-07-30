import 'package:flutter/material.dart';
import 'package:vet/component/loading_image_network.dart';
import 'package:vet/pages/ebook/ebook_form.dart';

class EbookListVertical extends StatefulWidget {
  EbookListVertical({Key? key, this.site, this.model}) : super(key: key);

  final String? site;
  final Future<dynamic>? model;

  @override
  _EbookListVertical createState() => _EbookListVertical();
}

class _EbookListVertical extends State<EbookListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          // print('snapshot.hasData');
          // print('snapshot.data.length ' + snapshot.data.length.toString());
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
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.5,
                ),
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EbookForm(
                                  code: snapshot.data[index]['code'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 200,
                            width: 150,
                            // decoration: BoxDecoration(
                            //     color: Color(0xFF7090AC),
                            //     borderRadius: BorderRadius.circular(5),
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.grey.withOpacity(0.3),
                            //         spreadRadius: 0,
                            //         blurRadius: 2,
                            //         offset: Offset(0, 1),
                            //       ),
                            //     ],
                            //     ),
                            margin: EdgeInsets.symmetric(
                              horizontal: 5.0,
                              vertical: 0.0,
                            ),
                            child: loadingImageNetworkClipRRect(
                              snapshot.data[index]['imageUrl'],
                              fit: BoxFit.cover,
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
                },
              ),
            );
          }
        } else {
          // print('snapshot.error');
          return Container(
            height: 800,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                10,
                (index) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.only(left: 30, right: 30),
                            child: Container(
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 0,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: new BorderRadius.circular(6.0),
                              ),
                            ),
                            // height: 205,
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
                },
              ),
            ),
          );
        }
      },
    );
  }
}
