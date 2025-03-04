import 'package:flutter/material.dart';
import 'package:insta_profile_viewer/helper/shared_pref.dart';
import 'package:insta_profile_viewer/screen/home/controller/home_controller.dart';
import 'package:insta_profile_viewer/screen/home/widget/favorite_user.dart';
import 'package:insta_profile_viewer/screen/search/search_screen.dart';
import 'package:insta_profile_viewer/utils/images.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    //add();
    // Kullanıcı listesini yükleme
    Provider.of<HomeController>(context, listen: false).getUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insta Story Viewer'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Image.asset(
                Images.logo,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text('Instagram', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text('Anonymous Story Viewer', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              SearchScreen(),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left:15, right: 15, bottom: 10),
                child: FavoriteUser(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
