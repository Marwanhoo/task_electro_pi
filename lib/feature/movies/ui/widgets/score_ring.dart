import 'package:flutter/material.dart';
import 'package:task_electro_pi/core/themes/app_colors.dart';

class ScoreRing extends StatelessWidget {
  const ScoreRing({super.key, required this.voteAverage, this.diameter = 38});

  final num voteAverage;
  final double diameter;

  int get scorePercentage => (voteAverage * 10).round();

  Color get ringColor {
    if (scorePercentage >= 70) {
      return AppColors.scoreGreen;
    }
    if (scorePercentage >= 40) {
      return AppColors.scoreYellow;
    }
    return AppColors.scoreRed;
  }

  Color get trackColor {
    if (scorePercentage >= 70) {
      return AppColors.scoreTrackGreen;
    }
    if (scorePercentage >= 40) {
      return AppColors.scoreTrackYellow;
    }
    return AppColors.scoreTrackRed;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        color: AppColors.tmdbNavy,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(3),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: diameter,
            height: diameter,
            child: CircularProgressIndicator(
              value: scorePercentage / 100,
              strokeWidth: 3,
              backgroundColor: trackColor,
              valueColor: AlwaysStoppedAnimation<Color>(ringColor),
            ),
          ),
          RichText(
            text: TextSpan(
              text: '$scorePercentage',
              style: TextStyle(
                color: AppColors.onBrand,
                fontSize: diameter * 0.30,
                fontWeight: FontWeight.w700,
              ),
              children: <InlineSpan>[
                TextSpan(
                  text: '%',
                  style: TextStyle(
                    color: AppColors.onBrand,
                    fontSize: diameter * 0.18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
