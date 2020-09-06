import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:returnlost/services/navigation_service.dart';
import 'package:returnlost/widgets/view_image.dart';

Widget thingImage(String imageURL, List<String> images) {
  return GestureDetector(
    child: CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageURL,
      placeholder: (context, url) => SpinKitFadingFour(
        color: Colors.black54,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
    onTap: () {
      NavigationService.instance.navigateToRoute(MaterialPageRoute(
          builder: (context) => ViewImage(images: images, imageURL: imageURL),
          fullscreenDialog: true));
    },
  );
}