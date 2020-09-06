import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ViewImage extends StatelessWidget {
  final String imageURL;
  final List<String> images;
  ViewImage({this.imageURL, this.images});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Carousel(
            borderRadius: true,
            showIndicator: true,
            autoplay: false,
            defaultImage: thingImage(imageURL),
            images: imageURL == images[0]
                ? [
                    thingImage(imageURL),
                    thingImage(images[1]),
                    thingImage(images[2]),
                  ]
                : imageURL == images[1]
                    ? [
                        thingImage(imageURL),
                        thingImage(images[0]),
                        thingImage(images[2]),
                      ]
                    : [
                        thingImage(imageURL),
                        thingImage(images[0]),
                        thingImage(images[1]),
                      ]),
      ),
    );
  }

  CachedNetworkImage thingImage(String imageURL) {
    return CachedNetworkImage(
      fit: BoxFit.contain,
      imageUrl: imageURL,
      placeholder: (context, url) => SpinKitFadingFour(
        color: Colors.black54,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
