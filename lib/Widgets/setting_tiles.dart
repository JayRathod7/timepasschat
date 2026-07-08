// lib/Widgets/setting_tiles.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../Constants/app_colors.dart';

class SettingsGridCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final List<Color>? gradient;
  final String? tag;
  final bool isDestructive;

  const SettingsGridCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.gradient,
    this.tag,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final List<Color> colors = isDestructive
        ? [
      AppColors.error.withOpacity(0.16),
      const Color(0xFFFFEEF1),
    ]
        : (gradient ??
        [
          AppColors.primary.withOpacity(0.16),
          AppColors.secondary.withOpacity(0.10),
        ]);

    final Color accentColor =
    isDestructive ? AppColors.error : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDestructive
                  ? AppColors.error.withOpacity(0.14)
                  : AppColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDestructive ? AppColors.error : AppColors.primary)
                    .withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.82),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 18,
                  ),
                ),
                const Gap(8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10.5,
                    height: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}