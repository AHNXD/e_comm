import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget(
      {super.key, required this.list, required this.height});
  final List<Widget> list;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
            // autoPlayInterval: Duration(seconds: 10),
            height: height,
            // enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            enableInfiniteScroll: false,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(seconds: 15),
            autoPlayCurve: Curves.fastOutSlowIn),
        items: list);
  }
}
