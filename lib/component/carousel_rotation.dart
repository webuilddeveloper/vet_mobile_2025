import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vet/component/loading_image_network.dart';

class CarouselRotation extends StatefulWidget {
  CarouselRotation({Key? key, this.model, this.nav}) : super(key: key);

  final Future<dynamic>? model;
  final Function(String, String, dynamic, String)? nav;

  @override
  _CarouselRotation createState() => _CarouselRotation();
}

class _CarouselRotation extends State<CarouselRotation> {
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
        // AsyncSnapshot<Your object type>

        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 120,
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
                      return new InkWell(
                        onTap: () {
                          widget.nav!(
                            snapshot.data[_current]['linkUrl'],
                            snapshot.data[_current]['action'],
                            snapshot.data[_current],
                            snapshot.data[_current]['code'],
                          );
                        },
                        child: Container(
                          child: Center(
                            child: loadingImageNetwork(
                              document['imageUrl'],
                              fit: BoxFit.fill,
                              height: 120,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
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
