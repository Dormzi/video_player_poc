@JS()
library web_player;

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:js/js.dart';

/// Eval javascript string
///
/// ex: eval('console.log("Hello")');
void eval(String script) {
  js.context.callMethod('eval', [script]);
}

void init() {
  importJQuery();
  disableAnalytics();
  importCss();
  importScript();
  listenEvents();
}

void importCss() {
  //<link href="https://vjs.zencdn.net/8.10.0/video-js.css" rel="stylesheet" />
  eval('''
    var mainCss = document.createElement('link');
    mainCss.rel = 'stylesheet';
    mainCss.href = 'https://unpkg.com/video.js@7/dist/video-js.min.css';    


    var cityTheme = document.createElement('link');
    cityTheme.rel = 'stylesheet';
    cityTheme.href = 'https://unpkg.com/@videojs/themes@1/dist/city/index.css';    

    document.head.appendChild(mainCss);
    document.head.appendChild(cityTheme);
  ''');
}

void importScript() {
  //<script src="https://vjs.zencdn.net/8.10.0/video.min.js"></script>
  eval('''
    var script = document.createElement('script');
    script.src = 'https://vjs.zencdn.net/8.10.0/video.min.js';
    script.type = 'text/javascript';

    document.body.appendChild(script);
  ''');
}

void importJQuery() {
  //<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  eval('''
    var script = document.createElement('script');
    script.src = 'https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js';
    script.type = 'text/javascript';

    document.body.appendChild(script);
  ''');
}

void disableAnalytics() {
  eval('window.HELP_IMPROVE_VIDEOJS = false');
}

void listenEvents() {
  const script = r'''
    $(document).ready(function() {
      const videoPlayer = document.getElementById('my-video');

      videoPlayer.addEventListener('play', function(e) {
        console.log('||PLAY||'+ e.currentTarget.currentTime);
      });

      videoPlayer.addEventListener('pause', function(e) {
        console.log('||PAUSE||'+ e.currentTarget.currentTime);
      });

      videoPlayer.addEventListener('ratechange', function() {
        console.log('||RATE CHANGE||');
      });

      videoPlayer.addEventListener('ended', function() {
        console.log('||Video Completed||');
      });

      videoPlayer.addEventListener('seeked', function(e) {
        console.log('||Seek||' + e.currentTarget.currentTime);
        
      });  

      // videoPlayer.addEventListener('volumechange', function(a) {
      //   console.log('||VOLUME||' + document.getElementById('my-video').volume);
      // });  
    });
  ''';
  eval(script);
}
