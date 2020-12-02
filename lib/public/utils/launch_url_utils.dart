import 'package:url_launcher/url_launcher.dart';

class LaunchUrlUtils {
  static launchURL(String downloadUrl) async {
    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }
}