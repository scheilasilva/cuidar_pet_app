import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  static Future<void> abrir(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('problema ao acessar o endereço');
    }
  }
}
