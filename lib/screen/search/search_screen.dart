import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:insta_profile_viewer/screen/search/controller/search_controller.dart';
import 'package:insta_profile_viewer/helper/toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SearchScreen extends StatefulWidget {
  final String? username;

  SearchScreen({this.username});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;
  final TextEditingController userNameController = TextEditingController();
  final ProfileSearchController searchController = Get.find<ProfileSearchController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1.25,
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: userNameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Instagram Username',
              suffixIcon: IconButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (userNameController.text.trim().isNotEmpty) {
                    await searchController.getUser(userNameController.text.trim(), context);
                  } else {
                    Toast().showSnackBar(context, 'Please enter a username.', isError: true);
                  }
                  setState(() {
                    isLoading = false;
                    userNameController.clear();
                  });
                },
                icon: const Icon(Icons.search_outlined, color: Color(0xFFD4AF37)),
              ),
            ),
          ),
        ),
        if (isLoading)
          Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: LoadingAnimationWidget.newtonCradle(color: Color(0xFFD4AF37), size: 200),
            ),
          ),
      ],
    );
  }

}
