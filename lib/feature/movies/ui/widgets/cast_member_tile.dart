import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/utils/app_strings.dart';
import 'package:task_electro_pi/feature/movies/data/model/cast_member_model.dart';

class CastMemberTile extends StatelessWidget {
  const CastMemberTile({
    super.key,
    required this.castMember,
  });

  final CastMemberModel castMember;

  String get profileImageUrl =>
      '${AppStrings.imageBaseUrl}${castMember.profilePath}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholderColor = theme.colorScheme.surfaceContainerHighest;

    return SizedBox(
      width: 100,
      child: Column(
        children: <Widget>[
          ClipOval(
            child: castMember.profilePath.isEmpty
                ? Container(
                    width: 72,
                    height: 72,
                    color: placeholderColor,
                    alignment: Alignment.center,
                    child: const Icon(Icons.person_outline, size: 32),
                  )
                : CachedNetworkImage(
                    imageUrl: profileImageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 72,
                      height: 72,
                      color: placeholderColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 72,
                      height: 72,
                      color: placeholderColor,
                      alignment: Alignment.center,
                      child: const Icon(Icons.person_outline, size: 32),
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Text(
            castMember.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            castMember.character,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
