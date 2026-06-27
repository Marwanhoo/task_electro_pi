import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/model/watch_provider_model.dart';

class WatchProviderTile extends StatelessWidget {
  const WatchProviderTile({
    super.key,
    required this.provider,
  });

  final WatchProviderModel provider;

  String get logoImageUrl =>
      '${AppStrings.providerLogoBaseUrl}${provider.logoPath}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholderColor = theme.colorScheme.surfaceContainerHighest;

    return SizedBox(
      width: 80,
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: provider.logoPath.isEmpty
                ? Container(
                    width: 56,
                    height: 56,
                    color: placeholderColor,
                    alignment: Alignment.center,
                    child: const Icon(Icons.play_circle_outline, size: 28),
                  )
                : CachedNetworkImage(
                    imageUrl: logoImageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 56,
                      height: 56,
                      color: placeholderColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 56,
                      height: 56,
                      color: placeholderColor,
                      alignment: Alignment.center,
                      child: const Icon(Icons.play_circle_outline, size: 28),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.providerName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
