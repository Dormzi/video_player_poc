import 'package:dio/dio.dart';

import 'failures.dart';
import 'vimeo_video_config.dart';

class VimeoService {
  final Dio dio;
  const VimeoService(this.dio);

  /// Calls Vimeo config api and returns a valid Vimeo video config (usually used to get the video .mp4 url)
  Future<VimeoVideoConfig> getVimeoVideoConfigFromId(String videoId) async {
    final response = await dio.get('https://player.vimeo.com/video/$videoId/config');
    final config = VimeoVideoConfig.fromJson(response.data);
    return config;
  }

  /// ## Returns the vimeo video id.<br/>
  /// Supported url formats: <br/>
  /// - `https://vimeo.com/70591644`
  /// - `www.vimeo.com/70591644`
  /// - `vimeo.com/70591644`
  String getVideoId(String url) {
    const videoIdGroup = 4;
    final exp = RegExp(r"^((https?)://)?(www.)?vimeo\.com/(\d+).*$");

    RegExpMatch? match = exp.firstMatch(url);
    if (match == null) return throw InvalidUrlFormatFailure(url);
    if (match.groupCount < videoIdGroup) return throw InvalidUrlFormatFailure(url);

    return match.group(videoIdGroup) ?? '';
  }

  /// used to check that the url format is valid vimeo video format
  bool isVimeoVideo(String url) {
    var regExp = RegExp(
      r"^((https?)://)?(www.)?vimeo\.com/(\d+).*$",
      caseSensitive: false,
      multiLine: false,
    );
    final match = regExp.firstMatch(url);
    if (match != null && match.groupCount >= 1) return true;
    return false;
  }
}
