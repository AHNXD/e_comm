import 'package:e_comm/Future/Home/Widgets/home_screen/offers_widget.dart';
import 'package:e_comm/Future/Home/Widgets/home_screen/product_card_widget.dart';

import 'package:e_comm/Future/Home/models/product_model.dart';
import 'package:flutter/material.dart';

List<Widget> offersList(List<MainProduct> data) {
  List<Widget> l = <Widget>[];

  for (int i = 0; i < data.length; i++) {
    l.add(OffersWidget(data: data[i]));
  }
  return l;
}

List<Widget> productCardList(bool isHomeScreen, List<MainProduct> li) {
  List<Widget> l = <Widget>[];

  for (int i = 0; i < li.length; i++) {
    l.add(
      ProductCardWidget(
          product: li[i], isHomeScreen: isHomeScreen, screen: "home"),
    );
  }
  return l;
}
