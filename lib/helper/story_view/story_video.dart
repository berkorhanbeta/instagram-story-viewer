import 'dart:async';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';

class VideoLoader {
  String url;

  File? videoFile;

  Map<String, dynamic>? requestHeaders;

  LoadState state = LoadState.loading;

  VideoLoader(this.url, {this.requestHeaders});

  void loadVideo(VoidCallback onComplete) {
    if (this.videoFile != null) {
      this.state = LoadState.success;
      onComplete();
    }

    final fileStream = DefaultCacheManager()
        .getFileStream(this.url, headers: this.requestHeaders as Map<String, String>?);

    fileStream.listen((fileResponse) {
      if (fileResponse is FileInfo) {
        if (this.videoFile == null) {
          this.state = LoadState.success;
          this.videoFile = fileResponse.file;
          onComplete();
        }
      }
    });
  }
}

class StoryVideo extends StatefulWidget {
  final StoryController? storyController;
  final VideoLoader videoLoader;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  StoryVideo(this.videoLoader, {
    Key? key,
    this.storyController,
    this.loadingWidget,
    this.errorWidget,
  }) : super(key: key ?? UniqueKey());

  static StoryVideo url(String url, {
    StoryController? controller,
    Map<String, dynamic>? requestHeaders,
    Key? key,
    Widget? loadingWidget,
    Widget? errorWidget,
  }) {
    return StoryVideo(
      VideoLoader(url, requestHeaders: requestHeaders),
      storyController: controller,
      key: key,
      loadingWidget: loadingWidget,
      errorWidget: errorWidget,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return StoryVideoState();
  }
}

class StoryVideoState extends State<StoryVideo> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  StreamSubscription? _streamSubscription;

  @override
  void initState() {
    super.initState();

    widget.storyController?.pause();

    // Network üzerinden video akışı sağlanır.
    _videoPlayerController = VideoPlayerController.network(
      widget.videoLoader.url
    );

    // Video hemen başlatılır
    _videoPlayerController.initialize().then((_) {
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          autoPlay: true,
          looping: true,
          showControls: false
        );
      });

      // StoryController'un oynatma durumunu güncelle
      widget.storyController?.play();
    });

    _streamSubscription = widget.storyController?.playbackNotifier.listen((playbackState) {
      if (playbackState == PlaybackState.pause) {
        _chewieController?.pause();
      } else {
        _chewieController?.play();
      }
    });
  }

  Widget getContentView() {
    if (_videoPlayerController.value.isInitialized && _chewieController != null) {
      return Chewie(controller: _chewieController!);
    }

    return widget.videoLoader.state == LoadState.loading
        ? Center(
      child: widget.loadingWidget ??
          Container(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ),
    )
        : Center(
      child: widget.errorWidget ??
          Text(
            "Media failed to load.",
            style: TextStyle(color: Colors.white),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: getContentView(),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }
}

