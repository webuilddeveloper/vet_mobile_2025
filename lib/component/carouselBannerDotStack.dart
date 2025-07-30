import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:vet/component/loading_image_network.dart';

class CarouselBannerDotStack extends StatefulWidget {
  CarouselBannerDotStack({Key? key, this.model, this.nav, this.height = 160})
      : super(key: key);

  final Future<dynamic>? model;
  final Function(String, String, dynamic, String, String)? nav;
  final double height;

  @override
  _CarouselBannerDotStack createState() => _CarouselBannerDotStack();
}

class _CarouselBannerDotStack extends State<CarouselBannerDotStack> {
  final txtDescription = TextEditingController();
  int _current = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Stack(
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        widget.nav!(
                          snapshot.data[_current]['linkUrl'],
                          snapshot.data[_current]['action'],
                          snapshot.data[_current],
                          snapshot.data[_current]['code'],
                          '',
                        );
                      },
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: widget.height,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          autoPlay: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: snapshot.data.map<Widget>(
                          (document) {
                            return Center(
                              child: loadingImageNetworkClipRRect(
                                document['imageUrl'],
                                fit: BoxFit.fill,
                                height: widget.height,
                                width: double.infinity,
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: (MediaQuery.of(context).size.height / 100) * 13,
                  ),
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: snapshot.data.map<Widget>((url) {
                      int index = snapshot.data.indexOf(url);
                      return Container(
                        width: _current == index ? 20.0 : 20.0,
                        height: 5.0,
                        margin: _current == index
                            ? EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 1.0,
                              )
                            : EdgeInsets.symmetric(
                                vertical: 5.0,
                                horizontal: 2.0,
                              ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _current == index
                              ? Color(0xFF1B6DA8)
                              : Color(0xFFF0F0F0),
                          boxShadow: [
                            BoxShadow(
                              color: _current == index
                                  ? Color(0xFF1B6DA8)
                                  : Color(0xFFF0F0F0),
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}
