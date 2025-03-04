import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:insta_profile_viewer/helper/toast.dart';
import 'package:insta_profile_viewer/model/instagram_profile_model.dart';
import 'package:insta_profile_viewer/screen/search/search_screen.dart';
import 'package:insta_profile_viewer/utils/app_constant.dart';
import 'package:insta_profile_viewer/utils/page_navigation.dart';

class ProfileSearchController {

  ProfileSearchController();

  Dio dio = Dio();
  InstagramProfileModel? instagramProfileModel;

  Future<void> getInstagramUser({
    required Function(String) onError,
    required String userName,
    int maxRetries = 3,
    int retryDelay = 2,
  }) async {
    int retryCount = 0;
    dio.options.headers = {
      'Referer': '',
      'Content-Type': 'application/json',
    };
    while (retryCount < maxRetries) {
      try {
        final response = await dio.get(AppConstant.userProfile + userName);
        instagramProfileModel = InstagramProfileModel.fromJson(response.data['result']['user']);
        Get.toNamed(PageNavigation.instagram);
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) {
          onError('Profil Bulunamadı.');
          return;
        }
        await Future.delayed(Duration(seconds: 3));
      }
    }
  }


  InstagramProfileModel? get instaModel => instagramProfileModel;

  Future<void> getUser(String username, BuildContext context) async {
    await getInstagramUser(
      userName: username,
      onError: (message) {
        Toast().showSnackBar(context, message, isError: true);
      },
    );

  }

}