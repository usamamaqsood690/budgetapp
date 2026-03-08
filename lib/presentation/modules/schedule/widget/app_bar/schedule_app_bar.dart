import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:wealthnxai/presentation/modules/schedule/widget/sliver_header_delegate.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/routes/app_routes.dart';

class SliverScheduleAppBar extends StatelessWidget {
  const SliverScheduleAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  SliverPersistentHeader(
      pinned: true,
      delegate: MyHeaderDelegate(
        minHeight: 60,
        maxHeight: 60,
        child: CustomAppBar(
          title: "Schedule",
          actionIcon: Icons.add,
          showAddIcon: true,
          onAddPressed: () {
            Get.toNamed(Routes.ADD_SCHEDULE);
          },
        ),
      ),
    );
  }
}
