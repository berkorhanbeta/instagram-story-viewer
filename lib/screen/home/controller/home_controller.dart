import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:insta_profile_viewer/helper/shared_pref.dart';
import 'package:insta_profile_viewer/helper/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends ChangeNotifier {
  List<Map<String, String>> userList = [];

  Future<void> getUserList() async {
    userList = await SharedPref().getData();
    notifyListeners();
  }

  Future<void> addUser(String name, String username, String photo, BuildContext context) async {
    if(await SharedPref().saveData(name, username, photo)){
      await getUserList();
      Toast().showSnackBar(context, 'Added', isError: false);
    } else {
      Toast().showSnackBar(context, 'Already in Fav', isError: true);
    }

  }

  Future<void> checkUserImage(String username, String photo) async {
    await SharedPref().checkUserImage(username, photo);
  }

  Future<void> deleteUser(String username, BuildContext context) async {
    await SharedPref().delData(username);
    await getUserList();
    Toast().showSnackBar(context, 'Deleted', isError: false);
  }


  String _percent = '0';
  String get percent => _percent;
  downloadVideoStory(String videoUrl, BuildContext context) async {
    if(await Permission.storage.request().isGranted || await Permission.manageExternalStorage.request().isGranted){
      var AppDocDir = await getTemporaryDirectory();
      String save = AppDocDir.path + '/story.mp4';
      await Dio().download(
          videoUrl.toString(),
          save,
          onReceiveProgress: (count, total){
            _percent = (count / total * 100).toStringAsFixed(0);
            notifyListeners();
          }
      );
      await ImageGallerySaverPlus.saveFile(save);
      Navigator.pop(context);
      Toast().showSnackBar(context, 'Story Succesfully downloaded.');
    }
  }

  downloadStory(String imageUrl, BuildContext context) async {
    if(await Permission.storage.request().isGranted || await Permission.manageExternalStorage.request().isGranted){
      var response = await Dio().get(
          imageUrl.toString(),
          options: Options(responseType: ResponseType.bytes)
      );
      final result = await ImageGallerySaverPlus.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
      );
      Toast().showSnackBar(context, 'Story Succesfully downloaded.');
    }
  }
}
