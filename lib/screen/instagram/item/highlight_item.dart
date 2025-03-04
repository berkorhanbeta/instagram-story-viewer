import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HighlightItem extends StatelessWidget {

  String? title;
  String? coverMedia;

  HighlightItem({required this.title, required this.coverMedia});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(coverMedia.toString()),
          radius: 40,
        ),
        Text(title.toString())
      ],
    );
  }

}