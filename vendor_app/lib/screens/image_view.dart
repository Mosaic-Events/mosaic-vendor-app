import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryWidget extends StatefulWidget {
  final PageController pageController;
  final List urls;
  final int index;
  GalleryWidget({
    super.key,
    required this.urls,
    this.index = 0,
  }) : pageController = PageController(initialPage: index);

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late int index = widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PhotoViewGallery.builder(
            pageController: widget.pageController,
            itemCount: widget.urls.length,
            builder: (context, index) {
              final url = widget.urls[index].toString();
              return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(url),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 2);
            },
            onPageChanged: (index) => setState(() {
              this.index = index;
            }),
          ),
          Text(
            '${index + 1}/${widget.urls.length}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
