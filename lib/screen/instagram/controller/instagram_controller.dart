import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:insta_profile_viewer/helper/story_view/story_view.dart';
import 'package:insta_profile_viewer/model/instagram_highlight_model.dart';
import 'package:insta_profile_viewer/model/instagram_story_model.dart';
import 'package:insta_profile_viewer/utils/app_constant.dart';
import 'package:story_view/controller/story_controller.dart';

class InstagramController extends ChangeNotifier {
  Dio dio = Dio();
  final controller = StoryController();

  List<InstagramStoryModel> storyModel = [];
  List<StoryItem> storyItems = [];
  bool storyLoading = false;

  List<InstagramHighlightModel> highlightModel = [];
  bool highlightLoading = false;

  Future<void> getStory(String username) async {
    storyLoading = true;
    storyModel = [];
    storyItems = [];


    await _loadData(
      url: AppConstant.userStory + username,
      onSuccess: (data) {
        var stories = data['result'] as List;
        storyModel = stories.map((v) => InstagramStoryModel.fromJson(v)).toList();
        for (var element in storyModel) {
          if (element.hasAudio ?? false) {
            storyItems.add(
              StoryItem.pageVideo(
                element.videoUrl ?? '',
                controller: controller,
                duration: const Duration(milliseconds: 1500),
              ),
            );
          } else {
            storyItems.add(
              StoryItem.pageImage(
                url: element.imageUrl ?? '',
                controller: controller,
                duration: const Duration(milliseconds: 1500),
              ),
            );
          }
        }
        storyLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> getHighlight(String userId) async {
    highlightLoading = true;
    highlightModel = [];

    await _loadData(
      url: AppConstant.userHighlight + userId,
      onSuccess: (data) {
        var highlights = data['result'] as List;
        highlightModel = highlights.map((v) => InstagramHighlightModel.fromJson(v)).toList();
        highlightLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> _loadData({
    required String url,
    required void Function(dynamic data) onSuccess,
    int maxRetries = 3,
    int retryDelay = 2,
  }) async {
    dio.options.headers = {
      'Referer': '',
      'Content-Type': 'application/json',
    };

    int retryCount = 0;
      try {
        final response = await dio.get(url);
        onSuccess(response.data);
        return;
      } catch (e) {
        retryCount++;
        print('Request failed ($retryCount/$maxRetries): $e');
        if (retryCount >= maxRetries) return; else {storyLoading = false; highlightLoading = false;}
        await Future.delayed(Duration(seconds: retryDelay));
      }
    }
}
