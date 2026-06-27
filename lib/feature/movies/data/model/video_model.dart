class VideoModel {
  final String id;
  final String key;
  final String site;
  final String type;
  final String name;

  const VideoModel({
    required this.id,
    required this.key,
    required this.site,
    required this.type,
    required this.name,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      key: json['key'] ?? '',
      site: json['site'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
    );
  }

  static VideoModel? selectYoutubeTrailer(List<VideoModel> videos) {
    final youtubeVideos =
        videos.where((video) => video.site == 'YouTube').toList();
    if (youtubeVideos.isEmpty) {
      return null;
    }

    for (final video in youtubeVideos) {
      if (video.type == 'Trailer') {
        return video;
      }
    }

    return youtubeVideos.first;
  }
}
