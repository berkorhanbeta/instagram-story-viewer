import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insta_profile_viewer/screen/home/controller/home_controller.dart';
import 'package:insta_profile_viewer/screen/home/item/favorite_user_item.dart';
import 'package:insta_profile_viewer/screen/search/controller/search_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class FavoriteUser extends StatelessWidget {
  final ProfileSearchController searchController = Get.find<ProfileSearchController>();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, homeController, child) {
        final userList = homeController.userList;

        if (userList.isEmpty) {
          return Center(child: Text('No favorite users yet.'));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final user = userList[index];
            return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                homeController.deleteUser(user['username'] ?? '', context);
              },
              background: Container(
                  alignment: Alignment.centerRight,
                  color: Colors.red,
                  child: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(Icons.delete_forever_rounded, color: Colors.white, size: 40),
                  )
              ),
              child: GestureDetector(
                onTap: () {
                  searchController.getUser(user['username'].toString(), context);
                },
                child: FavoriteUserItem(name: user['name'], username: user['username'], profilePhoto: user['photo']),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(),
        );
      },
    );
  }
}

/*

ListTile(
              title: Text('Name: ${user['name'] ?? ''}'),
              subtitle: Text('Username: ${user['username'] ?? ''}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  homeController.deleteUser(user['username'] ?? '');
                },
              ),
              onTap: () {
                searchController.getUser(user['username'].toString(), context);
              },
            );


 */