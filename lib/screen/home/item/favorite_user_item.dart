import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_profile_viewer/utils/images.dart';

class FavoriteUserItem extends StatelessWidget {

  String? name;
  String? username;
  String? profilePhoto;
  FavoriteUserItem({required this.name, required this.username, required this.profilePhoto});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 100,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profilePhoto ?? Images.placeHolder),
                radius: 30,
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${name}', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('${username}')
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }


}