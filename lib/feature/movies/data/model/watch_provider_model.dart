class WatchProviderModel {
  final int providerId;
  final String providerName;
  final String logoPath;

  const WatchProviderModel({
    required this.providerId,
    required this.providerName,
    required this.logoPath,
  });

  factory WatchProviderModel.fromJson(Map<String, dynamic> json) {
    return WatchProviderModel(
      providerId: json['provider_id'] ?? -1,
      providerName: json['provider_name'] ?? '',
      logoPath: json['logo_path'] ?? '',
    );
  }
}

class MovieWatchProvidersModel {
  final String? link;
  final List<WatchProviderModel> flatrate;
  final List<WatchProviderModel> rent;
  final List<WatchProviderModel> buy;

  const MovieWatchProvidersModel({
    this.link,
    required this.flatrate,
    required this.rent,
    required this.buy,
  });

  bool get isEmpty => flatrate.isEmpty && rent.isEmpty && buy.isEmpty;

  factory MovieWatchProvidersModel.empty() => const MovieWatchProvidersModel(
        flatrate: <WatchProviderModel>[],
        rent: <WatchProviderModel>[],
        buy: <WatchProviderModel>[],
      );

  factory MovieWatchProvidersModel.fromRegionJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MovieWatchProvidersModel.empty();
    }

    return MovieWatchProvidersModel(
      link: json['link'] as String?,
      flatrate: parseProviders(json['flatrate']),
      rent: parseProviders(json['rent']),
      buy: parseProviders(json['buy']),
    );
  }

  static List<WatchProviderModel> parseProviders(dynamic rawList) {
    if (rawList is! List<dynamic>) {
      return <WatchProviderModel>[];
    }

    final seenProviderIds = <int>{};
    final providers = <WatchProviderModel>[];

    for (final item in rawList) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final provider = WatchProviderModel.fromJson(item);
      if (provider.providerId == -1 || seenProviderIds.contains(provider.providerId)) {
        continue;
      }

      seenProviderIds.add(provider.providerId);
      providers.add(provider);
    }

    return providers;
  }
}
