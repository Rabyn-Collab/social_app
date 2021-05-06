import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
class PhotoViews extends StatelessWidget {
  final String imageUrl;

  const PhotoViews({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PhotoView(
          imageProvider: NetworkImage(
            imageUrl
          ),
        )
    );
  }
}
