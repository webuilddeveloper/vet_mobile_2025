import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'contact_list.dart';

class ContactListCategoryVertical extends StatefulWidget {
  ContactListCategoryVertical({
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
  _ContactListCategoryVertical createState() => _ContactListCategoryVertical();
}

class _ContactListCategoryVertical extends State<ContactListCategoryVertical> {
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
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactList(
                              title: snapshot.data[index]['title'],
                              code: snapshot.data[index]['code']),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 80.0,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: Color(0xFF1B6CA8),
                          ),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF7090AC),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Image.network(
                                    '${snapshot.data[index]['imageUrl']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                width: 50.0,
                                height: 50.0,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  '${snapshot.data[index]['title']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFFFFFFFF),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Color(0xFFFFFFFF),
                                  size: 40.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
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
}
