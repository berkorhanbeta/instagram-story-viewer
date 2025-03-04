import 'package:get/get.dart';
import 'package:insta_profile_viewer/screen/home/home_screen.dart';
import 'package:insta_profile_viewer/screen/instagram/instagram_profile_screen.dart';

class PageNavigation {

  static const String splash = '/';
  static const String home = '/home';
  static const String instagram = '/instagram';


  static final routes = [
    GetPage(name: home, page: () => HomeScreen()),
    GetPage(name: instagram, page: () => InstagramProfileScreen()),
  ];

}