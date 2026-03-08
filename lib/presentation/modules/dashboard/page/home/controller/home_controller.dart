/// Home Controller - Presentation layer
/// Manages home screen state and business logic
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import 'package:wealthnxai/presentation/modules/schedule/controller/schedule_controller.dart';

class HomeController extends GetxController {
  final AuthService authService = AuthService.instance;

  // Reactive state
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;

  StreamSubscription<UserEntity?>? _userSubscription;

  @override
  void onInit() {
    super.onInit();

    loadUserData();
    loadScheduleData();

    // Listen to user stream for updates
    _userSubscription = authService.userStream.listen((UserEntity? user) {
      currentUser.value = user;
    });
  }

  /// Load schedule data
  void loadScheduleData() {
    try {
      final scheduleController = Get.find<ScheduleController>();
      scheduleController.fetchUpcomingSchedule();
    } catch (e) {
      debugPrint('⚠️ ScheduleController not found: $e');
    }
  }

  /// Load current user data
  void loadUserData() {
    currentUser.value = authService.currentUser;
  }

  @override
  void onClose() {
    _userSubscription?.cancel();
    super.onClose();
  }
  final NumberFormat numberFormat = NumberFormat("#,##0.00", "en_US");

  /// Refresh user data
  Future<void> refreshUserData() async {
    isLoading.value = true;
    await authService.loadUserData();
    currentUser.value = authService.currentUser;
    isLoading.value = false;
  }

  Future<void> openDrawer(BuildContext context) async {
    Scaffold.of(context).openDrawer();
  }
}
