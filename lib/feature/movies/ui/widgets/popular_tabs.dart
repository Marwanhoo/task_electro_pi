import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';
import 'package:task_electro_pi/feature/movies/ui/movie_tab_constants.dart';

class PopularTabs extends StatelessWidget {
  const PopularTabs({
    super.key,
    required this.selectedTabIndex,
    required this.onTabSelected,
  });

  final int selectedTabIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          for (var tabIndex = 0;
              tabIndex < MovieTabConstants.tabTitles.length;
              tabIndex++)
            buildTab(theme, tabIndex),
        ],
      ),
    );
  }

  Widget buildTab(ThemeData theme, int tabIndex) {
    final isSelected = tabIndex == selectedTabIndex;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: () => onTabSelected(tabIndex),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              MovieTabConstants.tabTitles[tabIndex],
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: isSelected
                    ? theme.textTheme.titleMedium?.color
                    : theme.textTheme.titleMedium?.color?.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: isSelected ? 28 : 0,
              decoration: BoxDecoration(
                color: AppColors.tmdbBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
