import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> openYoutubeTrailer(String videoKey) async {
  final uri = Uri.parse('${AppStrings.youtubeWatchBaseUrl}$videoKey');
  if (await canLaunchUrl(uri)) {
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
  return false;
}
