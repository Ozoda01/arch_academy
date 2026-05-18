import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _resetProgress() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Progressni tozalash? ⚠️"),
        content: const Text("Haqiqatdan ham barcha darslar progressini va o'rganish natijalarini mutlaqo o'chirib yubormoqchimisiz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Bekor qilish"),
          ),
          TextButton(
            onPressed: () {
              final box = Hive.box('progress_box');
              box.clear();
              Navigator.pop(dialogContext);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.error,
                  content: const Text("Barcha o'quv progressi muvaffaqiyatli tozalandi!"),
                ),
              );
            },
            child: Text(
              "Tozalash",
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil sozlamalari"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            // Profile Card
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 54,
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryLight,
                    child: const Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ).animate().scale(duration: 400.ms, curve: Curves.backOut),
                  const SizedBox(height: 16),
                  
                  Text(
                    "Sardor Dasturchi",
                    style: AppTypography.h3.copyWith(
                      color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    "sardordev@mail.uz",
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            
            // Settings Options List
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.palette_outlined, color: AppColors.primary),
                    title: const Text("Mavzu reji"),
                    subtitle: Text(isDark ? "Qorong'u rejim (Dark)" : "Yorug'lik rejimi (Light)"),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (val) {
                        // Switch theme placeholder or notify theme state
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.language_outlined, color: AppColors.kotlinColor),
                    title: const Text("Ilova tili"),
                    trailing: Text(
                      "O'zbekcha 🇺🇿",
                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.help_outline_rounded, color: AppColors.javaColor),
                    title: const Text("Yordam va Aloqa"),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),
            
            const SizedBox(height: 40),
            
            // Reset Progress Utility button
            CustomButton(
              text: "Progressni tozalash",
              onPressed: _resetProgress,
              // elegant red error style for reset button
            ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
          ],
        ),
      ),
    );
  }
}
