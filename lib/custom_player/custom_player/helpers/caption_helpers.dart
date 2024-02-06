// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../models/caption_model.dart';
import '../../models/subtitle_model.dart';

const String _subRipTimeStamp = r'\d\d:\d\d:\d\d(\.|,)\d\d\d';
const String _subRipArrow = r' --> ';

Future<List<CaptionModel>> captionsLoad(SubtitleModel subtitleModel) async {
  try {
    if (subtitleModel == SubtitleModel.desactived()) return [];
    String? subtitleData;
    if (subtitleModel.isNetwork) {
      final response = await Dio().get<String>(subtitleModel.url!);
      subtitleData = response.data;
    } else {
      subtitleData = await File(subtitleModel.url!).readAsString();
    }
    return parseCaptionsFromSubRipString(subtitleData!.replaceAll('WEBVTT', '').trim());
  } catch (e) {
    log('CaptionsLoad Exception: $e');
    rethrow;
  }
}

List<CaptionModel> parseCaptionsFromSubRipString(String file) {
  final List<CaptionModel> captions = <CaptionModel>[];
  for (List<String> captionLines in _readSubRipFile(file)) {
    if (captionLines.length < 3) break;

    final int captionNumber = int.parse(captionLines[0]);
    final _StartAndEnd startAndEnd = _StartAndEnd.fromSubRipString(captionLines[1]);

    final String text = captionLines.sublist(2).join('\n');

    final CaptionModel newCaption = CaptionModel(
      number: captionNumber,
      start: startAndEnd.start,
      end: startAndEnd.end,
      text: text,
    );
    if (newCaption.start != newCaption.end) {
      captions.add(newCaption);
    }
  }

  return captions;
}

class _StartAndEnd {
  final Duration start;
  final Duration end;

  _StartAndEnd(this.start, this.end);

  static _StartAndEnd fromSubRipString(String line) {
    final RegExp format = RegExp(_subRipTimeStamp + _subRipArrow + _subRipTimeStamp);

    if (!format.hasMatch(line)) {
      return _StartAndEnd(Duration.zero, Duration.zero);
    }

    final List<String> times = line.split(_subRipArrow);

    final Duration start = _parseSubRipTimestamp(times[0]);
    final Duration end = _parseSubRipTimestamp(times[1]);

    return _StartAndEnd(start, end);
  }
}

Duration _parseSubRipTimestamp(String timestampString) {
  if (!RegExp(_subRipTimeStamp).hasMatch(timestampString)) {
    return Duration.zero;
  }

  final List<String> commaSections =
      (timestampString.contains('.') ? timestampString.split('.') : timestampString.split(','));
  final List<String> hoursMinutesSeconds = commaSections[0].split(':');

  final int hours = int.parse(hoursMinutesSeconds[0]);
  final int minutes = int.parse(hoursMinutesSeconds[1]);
  final int seconds = int.parse(hoursMinutesSeconds[2]);
  final int milliseconds = int.parse(commaSections[1]);

  return Duration(
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
  );
}

List<List<String>> _readSubRipFile(String file) {
  final List<String> lines = LineSplitter.split(file).toList();

  final List<List<String>> captionStrings = <List<String>>[];
  List<String> currentCaption = <String>[];
  int lineIndex = 0;
  for (final String line in lines) {
    final bool isLineBlank = line.trim().isEmpty;
    if (!isLineBlank) {
      currentCaption.add(line);
    }

    if (isLineBlank || lineIndex == lines.length - 1) {
      captionStrings.add(currentCaption);
      currentCaption = <String>[];
    }

    lineIndex += 1;
  }

  return captionStrings;
}
