import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:vimeo_video_player_poc/vimeo/web/web_player_api.dart' as web_player_api;

class WebPlayer extends StatefulWidget {
  final String videoUrl;
  const WebPlayer({super.key, required this.videoUrl});

  @override
  State<WebPlayer> createState() => _WebPlayerState();
}

class _WebPlayerState extends State<WebPlayer> {
  ///<link id="videojscss" rel="stylesheet" href="https://unpkg.com/video.js/dist/video-js.css">
  ///<script src="https://unpkg.com/video.js/dist/video.js"></script>

  @override
  void initState() {
    super.initState();
    web_player_api.init();
    ui.platformViewRegistry.registerViewFactory(
      'web-video-player',
      isVisible: true,
      (int viewId) => html.VideoElement()
        ..id = 'my-video'
        ..className = 'video-js vjs-theme-city'
        ..controls = true
        ..preload = 'auto'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none'
        // ..poster = 'MY_VIDEO_POSTER.jpg'
        ..dataset = {}
        ..children = [
          html.SourceElement()
            ..src = widget.videoUrl
            ..type = 'video/mp4',
          html.ParagraphElement()
            ..className = 'vjs-no-js'
            ..innerHtml = '''To view this video please enable JavaScript, 
              and consider upgrading to a web browser that 
              <a href="https://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>''',
        ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: 'web-video-player');
  }
}
