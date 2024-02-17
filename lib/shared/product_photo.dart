import 'package:flutter/material.dart';

ClipRRect productPhoto(String photo) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: SizedBox.fromSize(
      size: const Size.fromRadius(48),
      child: Image.network(
        photo,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('lib/assets/images/6720387.jpg');
        },
      ),
    ),
  );
}
