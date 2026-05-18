import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../courses/domain/entities/lesson.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

class YoutubePlayerPage extends StatefulWidget {
  final Lesson lesson;

  const YoutubePlayerPage({super.key, required this.lesson});

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  YoutubePlayerController? _controller;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkInitialProgress();
    _initializePlayer();
  }

  void _checkInitialProgress() {
    final box = Hive.box('progress_box');
    setState(() {
      _isCompleted = box.get(widget.lesson.id, defaultValue: false) as bool;
    });
  }

  void _initializePlayer() {
    final defaultUrl = "https://www.youtube.com/watch?v=k42Ksk37vEE";
    final url = widget.lesson.youtubeUrl ?? defaultUrl;
    final videoId = YoutubePlayer.convertUrlToId(url) ?? "k42Ksk37vEE";

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  void _markAsCompleted() {
    final box = Hive.box('progress_box');
    box.put(widget.lesson.id, true);
    
    // Save language progress tag to calculate aggregates
    box.put('lang_${widget.lesson.courseId}_${widget.lesson.id}', true);

    setState(() {
      _isCompleted = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              "Tabriklaymiz! Dars tugatilgan deb belgilandi.",
              style: AppTypography.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    _controller?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_controller == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
        ),
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.lesson.title),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Youtube Player Widget
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                ),
                
                // Details and Completion
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          widget.lesson.title,
                          style: AppTypography.h3.copyWith(
                            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Duration badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${widget.lesson.durationMin} daqiqa (YouTube)",
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Description
                        Text(
                          widget.lesson.description,
                          style: AppTypography.bodyMedium.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Complete Button
                        _isCompleted
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.success.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_rounded, color: AppColors.success),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Ushbu darsni yakunladingiz!",
                                      style: AppTypography.bodyLarge.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().scale(duration: 300.ms, curve: Curves.backOut)
                            : CustomButton(
                                text: "Darsni yakunladim",
                                onPressed: _markAsCompleted,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
