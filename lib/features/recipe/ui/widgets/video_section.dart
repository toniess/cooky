import 'package:cooky/theme/colors.dart';
import 'package:cooky/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class VideoSection extends StatefulWidget {
  final String videoId;

  const VideoSection({super.key, required this.videoId});

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context),
        const SizedBox(height: 16),
        _buildVideoPlayer(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.accentBrown.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.play_circle_outline,
            color: AppColors.accentBrown,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Recipe Video',
          style: AppTextStyles.heading(context).copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.neutralGrayDark,
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: YoutubePlayer(controller: _controller),
      ),
    );
  }
}
