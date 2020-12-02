import 'package:awesome_flutter/public/utils/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String url;
  final String errorImg;
  final double width;
  final double height;
  final BoxFit fit;
  final BorderRadius borderRadius;

  const ImageView({
    Key key,
    this.url,
    this.errorImg,
    this.width,
    this.height,
    this.fit,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0.0),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            ImageHelper.placeHolder(width: width, height: height),
        errorWidget: (context, url, error) => errorImg == null
            ? ImageHelper.error(width: width, height: height)
            : SizedBox(
                width: width,
                height: height,
                child: Image.asset(
                  errorImg,
                  width: width,
                  height: height,
                ),
              ),
      ),
    );
  }
}

class HeadImageView extends StatelessWidget {
  final String url;
  final String errorImg;
  final double width;
  final double height;
  final BoxFit fit;

  const HeadImageView({
    Key key,
    this.url,
    this.width,
    this.height,
    this.fit,
    this.errorImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) =>
            ImageHelper.placeHolder(width: width, height: height),
        errorWidget: (context, url, error) => errorImg == null
            ? ImageHelper.error(width: width, height: height)
            : SizedBox(
                width: width,
                height: height,
                child: Image.asset(
                  errorImg,
                  width: width,
                  height: height,
                ),
              ),
      ),
    );
  }
}
