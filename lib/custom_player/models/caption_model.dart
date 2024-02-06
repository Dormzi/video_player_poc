class CaptionModel {
  const CaptionModel({this.number, this.start, this.end, this.text = ''});

  final int? number;

  final Duration? start;

  final Duration? end;

  final String text;

  bool get isNone => this == none;

  static const CaptionModel none = CaptionModel(
    number: 0,
    start: Duration.zero,
    end: Duration.zero,
    text: '',
  );

  @override
  String toString() => '$runtimeType('
      'number: $number, '
      'start: $start, '
      'end: $end, '
      'text: $text)';

  @override
  operator ==(other) =>
      other is CaptionModel &&
      other.number == number &&
      other.start == start &&
      other.end == end &&
      other.text == text;

  @override
  int get hashCode => number.hashCode ^ start.hashCode ^ start.hashCode ^ end.hashCode ^ text.hashCode;
}
