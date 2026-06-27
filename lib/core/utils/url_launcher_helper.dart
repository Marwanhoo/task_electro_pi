import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) {
    return false;
  }

  if (await canLaunchUrl(uri)) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  return false;
}

Future<bool> openYoutubeTrailer(String videoKey) async {
  return openExternalUrl('${AppStrings.youtubeWatchBaseUrl}$videoKey');
}
