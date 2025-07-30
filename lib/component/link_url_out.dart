import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  // if (await canLaunch(url)) {
  //   await launch(url);
  // } else {
  //   throw 'Could not launch $url';
  // }
}
