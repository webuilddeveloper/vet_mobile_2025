import 'package:flutter/material.dart';

loadingImageNetwork(String url, {BoxFit? fit, double? height, double? width}) {
  if (url == 'null' || url.isEmpty) {
    return Image.asset(
      'assets/images/file_picture.png',
      width: width,
      height: height,
    );
  }
  return Image.network(
    url,
    fit: fit ?? BoxFit.cover,
    height: height,
    width: width,
    loadingBuilder:
        (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
      if (loadingProgress == null) return child;
      return Center(child: CircularProgressIndicator());
    },
  );
}


loadingImageNetworkClipRRect(String url,
    {BoxFit? fit, double? height, double? width}) {
  if (url.isEmpty) url = '';
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: Image.network(
      url,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: loadingProgress.expectedTotalBytes != null
              ? CircularProgressIndicator()
              : Container(),
        );
      },
    ),
  );
}
