# vimeo_video_player_poc

This POC was created to research what approach is the best option to play [Vimeo](https://vimeo.com/watch) videos.

### Some notes:
 - The package `vimeo_video_player` only makes a request to a Vimeo api and plays the video using another video package. Unfortunately the video player they have chosen doesn't work on Web.
 - The package `appinio_video_player` works well in **Android** and **IOS** devices, but doesn't works well on **Web** platform 
    - don't have a button to change the volume 
    - don't have a full screen button
    - the settings button is overlapped by the cast icon
 - The package `chewie` works well in all the platforms, but on Web when go back from full-screen mode it stop playing the video.
 - The html/javascript player works fine and it's logging some events using javascript. In the real player it will need to make the JS side trigger a Flutter function. 

### The conclusion was:
 - The videos are gonna be hosted on [Vimeo](https://vimeo.com/watch);
 - To play Vimeo videos we only have to call an API passing the video ID and it will return the video url;
 - All the video player packages that works on web have issues, so it's better to use a html/javascript player for web.
 - This idea is only for the first version of the player, the best way to implement every thing as we want _(like criptography)_ is to customize our own video player.

### Folders structure

-| **lib** <br/>
----| **custom_player** - _a folder containing a custom player ui using **video_player**_ <br/>
----| **vimeo** <br/>
--------| **web** - _has the javascript video player for web_ <br/>
--------| **failures.dart** - _the possible failures when call the Vimeo api_ <br/>
--------| **log_video_player_controller.dart** - _custom controller that logs all the required events_ <br/>
--------| **vimeo_player.dart** - _the player itself that calls the Vimeo API and plays the video using the right player_ <br/>
--------| **vimeo_service.dart** - _service that get the video id from the URL and calls the Vimeo API_ <br/>
--------| **vimeo_store.dart** - _store where the video configuration will be saved_ <br/>
--------| **vimeo_video_config.dart** - _model of Vimeo API response_ <br/>
```
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
