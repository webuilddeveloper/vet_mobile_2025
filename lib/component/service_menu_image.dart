import 'package:flutter/material.dart';

/// Displays the visible photo, excluding transparent padding in menu assets.
class ServiceMenuImage extends StatelessWidget {
  const ServiceMenuImage({super.key, required this.assetPath});

  final String assetPath;

  // Pixel bounds of the nontransparent content in the original assets.
  static const _bounds = {
    'assets/images/01.png': Rect.fromLTWH(0, 0, 1000, 734),
    'assets/images/02.png': Rect.fromLTWH(0, 132, 1000, 736),
    'assets/images/03.png': Rect.fromLTWH(0, 167, 1000, 666),
    'assets/images/04.png': Rect.fromLTWH(0, 167, 1000, 666),
    'assets/images/06.png': Rect.fromLTWH(339, 125, 1298, 865),
  };

  @override
  Widget build(BuildContext context) {
    final bounds = _bounds[assetPath];
    if (bounds == null) {
      return Image.asset(assetPath, fit: BoxFit.cover);
    }
    final sourceSize =
        assetPath == 'assets/images/06.png'
            ? const Size(1920, 1080)
            : const Size(1000, 1000);

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: bounds.width,
        height: bounds.height,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: -bounds.left,
              top: -bounds.top,
              width: sourceSize.width,
              height: sourceSize.height,
              child: Image.asset(assetPath, fit: BoxFit.fill),
            ),
          ],
        ),
      ),
    );
  }
}
