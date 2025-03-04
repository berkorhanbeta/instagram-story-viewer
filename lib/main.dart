import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_profile_viewer/screen/home/controller/home_controller.dart';
import 'package:insta_profile_viewer/screen/instagram/controller/instagram_controller.dart';
import 'package:insta_profile_viewer/screen/search/controller/search_controller.dart';
import 'package:insta_profile_viewer/theme/app_theme.dart';
import 'package:insta_profile_viewer/utils/page_navigation.dart';
import 'package:provider/provider.dart';

void main() {
  Get.put(ProfileSearchController());
  Get.put(HomeController());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => InstagramController())
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Story Viewer',
      theme: theme,
      debugShowCheckedModeBanner: false,
      getPages: PageNavigation.routes,
      initialRoute: PageNavigation.home,
      scrollBehavior: const MaterialScrollBehavior().copyWith(dragDevices: {
        PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus,
        PointerDeviceKind.unknown
      }, scrollbars: false),
    );
  }
}
