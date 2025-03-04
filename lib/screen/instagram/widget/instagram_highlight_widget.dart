import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_profile_viewer/helper/story_view/story_view.dart';
import 'package:insta_profile_viewer/model/instagram_highlight_model.dart';
import 'package:insta_profile_viewer/model/instagram_story_model.dart';
import 'package:insta_profile_viewer/utils/app_constant.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart' as sv;

import '../controller/instagram_controller.dart';

class InstagramHighlightWidget extends StatefulWidget {

  String? userId;
  String? fullName;
  String? profile_pic;
  InstagramHighlightWidget({required this.userId, required this.fullName, required this.profile_pic});
  @override
  State<InstagramHighlightWidget> createState() => _InstagramHighlightWidgetState();

}

class _InstagramHighlightWidgetState extends State<InstagramHighlightWidget> {


  @override
  void initState() {
    super.initState();
    Provider.of<InstagramController>(context, listen: false).getHighlight(widget.userId.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InstagramController>(
      builder: (context, instagramController, child) {
        final highlightList = instagramController.highlightModel;
        if(instagramController.highlightLoading){
          return Center(child: LoadingAnimationWidget.fourRotatingDots(color: Color(0xFFD4AF37), size: 50));
        } else if(highlightList.isNotEmpty){
          return Container(
            margin: EdgeInsets.only(left: 5, right: 5),
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: highlightList.length,
              itemBuilder: (context, index) {
                var highlight = highlightList[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      openCarousel(highlight.highlightId.toString());
                    });
                  },
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(highlight.coverMedia.toString()),
                        radius: 35,
                      ),
                      Text(highlight.title.toString())
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: 20);
              },
            ),
          );
        } else {
          return Center(child: Text("No highlight found."));
        }
      },
    );
  }

  openCarousel(String hId) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()), // Yükleme göstergesi
        );
      },
    );

    await getHighlight(hId: hId);
    Navigator.pop(context);

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: StoryView(
                  storyItems: storyItems,
                  controller: controller, // pass controller here too
                  repeat: true, // should the stories be slid forever
                  onComplete: () {},
                  onVerticalSwipeComplete: (direction) {
                    if (direction == sv.Direction.down) {
                      Navigator.pop(context);
                    }
                  } // To disable vertical swipe gestures, ignore this parameter.
              )
          );
        }
    );
  }

  List<InstagramStoryModel> storyModel = [];
  final controller = sv.StoryController();
  List<StoryItem> storyItems = [];
  Dio dio = Dio();
  Future<void> getHighlight({
    int maxRetries = 3,
    int retryDelay = 2,
    required String hId
  }) async {
    int retryCount = 0;
    dio.options.headers = {
      'Referrer': 'https://anonyig.com/en/',
      'Content-Type': 'application/json',
    };
    while(retryCount < maxRetries) {
      try{
        storyModel = [];
        storyItems = [];
        final response = await dio.get(AppConstant.userShowHighlight + hId);
        var stories = response.data['result'] as List;
        setState(() {
          storyModel = stories.map((v) => InstagramStoryModel.fromJson(v)).toList();
          storyModel.forEach((element) async {
            if(element.hasAudio!){
              storyItems.add(StoryItem.pageVideo(
                  element.videoUrl!, 
                  controller: controller, 
                  duration: Duration(seconds: 325), 
                  usernName: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('${widget.profile_pic}'),
                        radius: 20,
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text('${widget.fullName}', style: TextStyle(fontSize: 10)),
                          Text('${element.takenAt}', style: TextStyle(fontSize: 10))
                        ],
                      )
                    ],
                  ),
              ));
            } else {
              storyItems.add(StoryItem.pageImage(url: element.imageUrl!, controller: controller, duration: Duration(seconds: 325)));
            }
          });
        });
        return;
      } catch(e){
        print(e);
        if(retryCount >= maxRetries){
          setState(() {});
          return;
        }
        await Future.delayed(Duration(seconds: retryDelay));
      }
    }
  }

}