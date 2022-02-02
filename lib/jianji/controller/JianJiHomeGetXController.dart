import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JianJiHomeGetXController extends GetxController {
  final PageController pageController = PageController(initialPage: 0);

  Future<void> animateToPage(int index) async {
    await pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeOutCirc);
  }

  Future<void> animateToPage0() async {
    await animateToPage(0);
  }

  Future<void> animateToPage1() async {
    await animateToPage(1);
  }
}
