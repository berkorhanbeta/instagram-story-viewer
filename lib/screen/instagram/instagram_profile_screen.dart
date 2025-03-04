import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_profile_viewer/model/instagram_profile_model.dart';
import 'package:insta_profile_viewer/screen/home/controller/home_controller.dart';
import 'package:insta_profile_viewer/screen/instagram/widget/instagram_highlight_widget.dart';
import 'package:insta_profile_viewer/screen/search/controller/search_controller.dart';
import 'package:insta_profile_viewer/utils/images.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widget/instagram_story_widget.dart';

class InstagramProfileScreen extends StatefulWidget {
  @override
  State<InstagramProfileScreen> createState() => _InstagramProfileScreenState();
}

class _InstagramProfileScreenState extends State<InstagramProfileScreen> {
  InstagramProfileModel? im;

  Future<InstagramProfileModel?> loadData() async {
    return await Get.find<ProfileSearchController>().instagramProfileModel;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InstagramProfileModel?>(
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          im = snapshot.data;

          Provider.of<HomeController>(context, listen: false)
              .checkUserImage(
              im!.username.toString(),
              im!.profile_pic_url.toString()
          );

          return Scaffold(
            appBar: AppBar(
              title: Text('${im?.username ?? 'Instagram Profile'}'),
              actions: [
                GestureDetector(
                  onTap: () {
                    Provider.of<HomeController>(context, listen: false)
                        .addUser(
                        im!.full_name.toString(),
                        im!.username.toString(),
                        im!.profile_pic_url.toString(),
                        context
                    );
                  },
                  child: Container(margin: EdgeInsets.only(right: 10), child: Icon(Icons.star)),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            accountHeader(),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: accountDetails(),
                            ),
                          ],
                        ),
                      )
                  ),
                  SizedBox(height: 10),
                  InstagramHighlightWidget(userId: im?.userId, fullName: im?.full_name, profile_pic: im?.profile_pic_url),
                  SizedBox(height: 10),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.6, // Provide fixed height
                      child: InstagramStoryWidget(userName: im?.username ?? ''),
                    ),
                  ),
                  SizedBox(height: 15)
                ],
              ),
            )
          );
        }

        return Center(
          child: Text('Failed to load data. Please try again later.'),
        );
      },
    );
  }

  Widget accountHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.black,
          backgroundImage: im?.profile_pic_url != null
              ? NetworkImage(im!.profile_pic_url!)
              : NetworkImage(Images.placeHolder),
        ),
        Expanded(
          child: Column(
            children: [
              Text('${im?.media_count ?? '0'}'),
              Text(
                'posts',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('${im?.follower_count ?? '0'}'),
              Text(
                'followers',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('${im?.following_count ?? '0'}'),
              Text(
                'following',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget accountDetails() {
    print('${im?.biography}');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(im?.full_name ?? 'Full Name Not Available', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Text(
          '${im?.biography}' ?? 'Bio Not Available',
          overflow: TextOverflow.visible,
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: () async {
            if(im?.external_url != null) {
              final Uri url = Uri.parse(im!.external_url!);
              if(!await launchUrl(url)){
                throw Exception('Error launching $url');
              }
            }
          },
          child: Text(
              im?.external_url ?? '',
              overflow: TextOverflow.visible,
              softWrap: true
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
