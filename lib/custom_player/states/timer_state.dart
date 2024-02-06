import '../core/notifier_store.dart';

class TimerState implements StoreState {
  final Duration duration;
  final Duration position;
  int get durationMilliseconds => (duration.inMilliseconds == 0) ? 1 : duration.inMilliseconds;
  int get positionMilliseconds => (position.inMilliseconds == 0) ? 1 : position.inMilliseconds;
  String get formattedPosition => _formatDuration(position);
  String get formattedDuration => _formatDuration(duration);

  const TimerState({required this.duration, required this.position});
  const TimerState.empty()
      : duration = Duration.zero,
        position = Duration.zero;

  TimerState copyWith({Duration? duration, Duration? position}) {
    return TimerState(
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }

  String _formatTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  String _formatDuration(Duration duration) {
    String twoDigitHours = _formatTwoDigits(duration.inHours.remainder(Duration.hoursPerDay));
    String twoDigitMinutes = _formatTwoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
    String twoDigitSeconds = _formatTwoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}
