import 'package:flutter/material.dart';
import 'package:srsappmultiplatform/domain/entities/WorkoutPlanData.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ExerciseDescriptionScreen extends StatefulWidget {
  final Exercise exercise;

  ExerciseDescriptionScreen({required this.exercise});

  @override
  _ExerciseDescriptionScreenState createState() =>
      _ExerciseDescriptionScreenState();
}

class _ExerciseDescriptionScreenState extends State<ExerciseDescriptionScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.exercise.video.isNotEmpty) {
      initializePlayer();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.exercise.video)
      ..addListener(_handleVideoPlayerError);

    await _videoPlayerController.initialize().catchError((error) {
      print('Video player initialization error: $error');
    });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );
    setState(() {});
  }

  void _handleVideoPlayerError() {
    if (_videoPlayerController.value.hasError) {
      print('Video player error: ${_videoPlayerController.value.errorDescription}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display note
              Text(
                'Note:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(widget.exercise.notes),
              SizedBox(height: 16),
              // Display photo
              if (widget.exercise.photo.isNotEmpty) ...[
                Text(
                  'Photo:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Image.network(widget.exercise.photo),
                SizedBox(height: 16),
              ],
              // Display video
              if (widget.exercise.video.isNotEmpty && _chewieController != null)
                ...[
                  Text(
                    'Video:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Chewie(
                    controller: _chewieController!,
                  ),
                ],
            ],
          ),
        ),
      ),
    );
  }
}
