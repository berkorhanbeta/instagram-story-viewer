import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_profile_viewer/model/instagram_story_model.dart';
import 'package:insta_profile_viewer/screen/instagram/controller/instagram_controller.dart';
import 'package:insta_profile_viewer/screen/instagram/item/insta_story_item.dart';
import 'package:insta_profile_viewer/utils/app_constant.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';
import 'package:video_player/video_player.dart';

class InstagramStoryWidget extends StatefulWidget {
  final String? userName;
  InstagramStoryWidget({Key? key, required this.userName}) : super(key: key);

  @override
  State<InstagramStoryWidget> createState() => _InstagramStoryWidgetState();
}

class _InstagramStoryWidgetState extends State<InstagramStoryWidget> {

  @override
  void initState() {
    super.initState();
    Provider.of<InstagramController>(context, listen: false).getStory(widget.userName.toString());
  }

  late VideoPlayerController _videoPlayerController;
  Future<void> showVideo(String url, BuildContext context) async {
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoPlayerController.initialize();
    final chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: true,
      looping: true,
      allowFullScreen: true,
      showControlsOnInitialize: true,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: AspectRatio(
            aspectRatio: chewieController.videoPlayerController.value.aspectRatio,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Chewie(controller: chewieController),
                GestureDetector(
                  onTap: () {
                    chewieController.dispose();
                    _videoPlayerController.dispose();
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close_outlined,
                    size: 48,
                    color: CupertinoColors.systemGrey5,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  showImage(String url){
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 2,
                child: Image.network(url, fit: BoxFit.cover),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close_outlined,
                  size: 48,
                  color: CupertinoColors.systemGrey5,
                ),
              )
            ],
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InstagramController>(
      builder: (context, instagramController, child) {
        final storyList = instagramController.storyModel;
        if(instagramController.storyLoading){
          return Center(child: LoadingAnimationWidget.fourRotatingDots(color: Color(0xFFD4AF37), size: 50));
        } else if(storyList.isNotEmpty){
          return ListView.separated(
            itemCount: storyList.length,
            itemBuilder: (context, index) {
              var story = storyList[index];
              return GestureDetector(
                  onTap: () {
                    if (story.hasAudio == true) {
                      showVideo(story.videoUrl!, context);
                    } else {
                      showImage(story.imageUrl!);
                    }
                  },
                  child: InstaStoryItem(imageUrl: story.imageUrl, hasAudio: story.hasAudio, date: story.takenAt, videoUrl: story.videoUrl ?? '')
              );
            },
            separatorBuilder: (context, index) {
              return Divider(height: 25);
            },
          );
        } else {
          return Center(child: Text("No story found."));
        }
      }
    );
  }
}
