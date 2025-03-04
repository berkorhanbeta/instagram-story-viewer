import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:insta_profile_viewer/helper/toast.dart';
import 'package:insta_profile_viewer/screen/home/controller/home_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class InstaStoryItem extends StatelessWidget {

  String? imageUrl;
  bool? hasAudio;
  String? date;
  String? videoUrl;

  InstaStoryItem({super.key, required this.imageUrl, required this.hasAudio, required this.date, required this.videoUrl});


  downloadVideoStory(BuildContext context){
    Provider.of<HomeController>(context, listen: false).downloadVideoStory(videoUrl.toString(), context);
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Consumer<HomeController>(
                      builder: (context, homeController, child) {
                        return Text(
                          '${homeController.percent}%',
                          style: const TextStyle(color: Colors.white, fontSize: 24),
                        );
                      },
                    ),
                  ),
                ),
                Positioned.fill(
                  child: LoadingAnimationWidget.beat(
                    color: const Color(0xFFD4AF37),
                    size: 100,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return hasAudio == true
        ? Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Image.network(
            imageUrl!,
            fit: BoxFit.fitHeight,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              color: Colors.black54,
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      color: Color(0x4C000000),
                      padding: EdgeInsets.all(15),
                      child: Text('${date}', textAlign: TextAlign.right),
                ))
              ],
            )
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      color: Color(0x4C000000),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Color(0xFFD4AF37),
                                width: 2.5
                            ),
                        ),
                        onPressed: () async {
                          downloadVideoStory(context);
                        },
                        child: Text('Download Story', style: TextStyle(color: Color(0xFFD4AF37))),
                      ),
                    ),
                  )
                ],
              )
          ),
        )
      ],
    ) : Stack(
      children: [
        Image.network(
          imageUrl!,
          fit: BoxFit.fitHeight,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.all(20),
            child: Text('${date}'),
          )
        ),
        Positioned.fill(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20),
                child: OutlinedButton(
                  onPressed: () async {
                    Provider.of<HomeController>(context, listen: false).downloadStory(imageUrl.toString(), context);
                  },
                  child: Text('Download Story'),
                ),
              )
          ),
        )
      ],
    );
  }

}