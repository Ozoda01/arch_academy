import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../courses/domain/entities/lesson.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/custom_button.dart';

class VideoPlayerPage extends StatefulWidget {
  final Lesson lesson;

  const VideoPlayerPage({super.key, required this.lesson});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
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

  Future<void> _initializePlayer() async {
    // Default video URL fallback in case URL is null
    final videoUrl = widget.lesson.videoUrl ?? "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4";
    
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        allowFullScreen: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white54,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Video Player Initialization Error: $e");
      // Handle error cleanly
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _markAsCompleted() {
    final box = Hive.box('progress_box');
    box.put(widget.lesson.id, true);
    
    // Save language progress tag to calculate aggregates
    // Saving "completed_courses_101" etc.
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
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player Container
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : (_chewieController != null
                        ? Chewie(controller: _chewieController!)
                        : const Center(
                            child: Text(
                              "Videoni yuklashda xatolik yuz berdi",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
              ),
            ),
            
            // Lesson Description and Progress marking
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
                        "${widget.lesson.durationMin} daqiqa",
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
  }
}
