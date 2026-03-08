import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/api_constants.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/web_view/web_view_screen.dart';

class DiscordCard extends StatelessWidget {
  const DiscordCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => WebViewScreen(
            url: ApiConstants.discordLink,
            onHeightChanged: (newHeight) {},
            title: 'Discord Community',
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF19C4A8), Colors.black.withOpacity(0.59)],
          ),
          border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  const AppText(
                    txt: 'Join Our Community',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Text(
                    maxLines: 3,
                        'Join our Discord Community to get access to new features before anyone & help us improve WealthNX',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,

                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.addWidth(19),
            SvgPicture.asset(ImagePaths.discordIcon, height: 31, width: 31),
          ],
        ),
      ),
    );
  }
}
