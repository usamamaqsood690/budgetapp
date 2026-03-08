import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/services/firebase_service.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/modules/intro/onboarding/widget/slide_widget.dart';

/// Onboarding Controller
/// Manages onboarding screen state and logic
class onBoardingController extends GetxController {
  var currentPage = 0.obs;
  final pageController = PageController(initialPage: 0);
  Timer? _timer;

  final double screenWidth = Get.width;
  final double screenHeight = Get.height;


  @override
  void onInit() {
    super.onInit();
    startAutoScroll();
    _initializeFirebase();
  }


  List<Widget> myWidgetList = [
    SlideWidget(title: 'Ask Anything'.tr, subtitle: 'Stock, Crypto Agents'.tr),
    SlideWidget(
      title: 'Analyze Finance',
      subtitle: 'Accountant, Build mode Agents'.tr,
    ),
    SlideWidget(
      title: 'All in One'.tr,
      subtitle: 'Ask AI, Analyze, Optimize'.tr,
    ),
  ];

  /// Function to start auto-scrolling
  void startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (currentPage.value < myWidgetList.length - 1) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }
      pageController.animateToPage(
        currentPage.value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  getIntroImage(String image) {
    return Image.asset(image, fit: BoxFit.contain);
  }

  getProgressLine(
    BuildContext context, {
    required Color color1,
    required Color color2,
    required Color color3,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        getContainer(color1),
        SizedBox(width: AppSpacing.sm),
        getContainer(color2),
        SizedBox(width: AppSpacing.sm),
        getContainer(color3),
      ],
    );
  }

  Widget getContainer(Color color) {
    return Container(
      width: AppDimensions.iconXS,
      height: AppDimensions.iconXS,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  /// Initialize Firebase Messaging and request permissions
  Future<void> _initializeFirebase() async {
    try {
      await FirebaseService.instance.initialize();
    } catch (e) {
      // Handle error silently or log it
      print('Error initializing Firebase on onboarding: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
