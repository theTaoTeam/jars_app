import 'package:flutter/material.dart';

DecorationImage buildBackgroundImage(AssetImage image) {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
      image: image,
    );
  }