class VimeoVideoConfig {
  final VimeoRequest? request;
  const VimeoVideoConfig({this.request});

  static VimeoVideoConfig fromJson(Map<String, dynamic> json) {
    return VimeoVideoConfig(request: VimeoRequest.fromJson(json["request"]));
  }
}

class VimeoRequest {
  final VimeoFiles? files;
  const VimeoRequest({this.files});

  static VimeoRequest fromJson(Map<String, dynamic> json) {
    return VimeoRequest(files: VimeoFiles.fromJson(json["files"]));
  }
}

class VimeoFiles {
  final List<VimeoProgressive?>? progressive;
  const VimeoFiles({this.progressive});

  static VimeoFiles fromJson(Map<String, dynamic> json) {
    return VimeoFiles(
      progressive: List<VimeoProgressive>.from(
        json["progressive"].map((x) => VimeoProgressive.fromJson(x)),
      ),
    );
  }
}

class VimeoProgressive {
  VimeoProgressive({
    required this.profile,
    required this.width,
    required this.mime,
    required this.fps,
    required this.url,
    required this.cdn,
    required this.quality,
    required this.id,
    required this.origin,
    required this.height,
  });

  factory VimeoProgressive.fromJson(Map<String, dynamic> json) {
    return VimeoProgressive(
      profile: json["profile"],
      width: json["width"]?.toDouble(),
      mime: json["mime"],
      fps: json["fps"],
      url: json["url"],
      cdn: json["cdn"],
      quality: json["quality"],
      id: json["id"],
      origin: json["origin"],
      height: json["height"]?.toDouble(),
    );
  }

  String profile;
  double width;
  String mime;
  int fps;
  String url;
  String cdn;
  String quality;
  String id;
  String origin;
  double height;
}
