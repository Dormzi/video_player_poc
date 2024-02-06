class SubtitleModel {
  final String name;
  final String? url;
  bool get isNetwork => url?.startsWith("http") == true;

  const SubtitleModel.desactived()
      : name = "Sem legendas",
        url = null;

  const SubtitleModel({
    required this.name,
    required this.url,
  });

  SubtitleModel copyWith({String? name, String? url}) {
    return SubtitleModel(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  @override
  operator ==(other) => other is SubtitleModel && name == other.name;

  @override
  int get hashCode => name.hashCode ^ url.hashCode;
}
