abstract class ICustomPlayer {
  Future<void> initialize();
  void listenDuration(void Function(Duration position, Duration duration) listenerCallback);
  void listenVideoEnd(void Function() listenerCallback);
  Future<void> play();
  Future<void> pause();
  Future<void> stop();
  Future<void> seekTo(Duration position);
  Future<Duration> getCurrentPosition();
  Future<Duration> getDuration();
}
