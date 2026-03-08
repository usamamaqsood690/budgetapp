import 'package:flutter/material.dart';
import 'package:wealthnxai/core/constants/app_images_path.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';

class SelectionItemTile extends StatelessWidget {
  const SelectionItemTile({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.showIcon = false,
    required this.isCategory,
    this.urlLogo,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showIcon;
  final bool isCategory;
  final String? urlLogo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showIcon) ...[
                  Row(
                    children: [
                      isCategory
                          ? AppImageAvatar(
                            fallbackAsset: ImagePaths.bank_icon,
                            avatarUrl: urlLogo,
                            isCircular: true,
                            radius: 15,
                          )
                          : Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(width: 0.5),
                              color:
                                  urlLogo == null
                                      ? Colors.transparent
                                      : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child:
                                  urlLogo != null
                                      ? Image.network(
                                        urlLogo!,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                                  ImagePaths.dfaccount,
                                                ),
                                      )
                                      : Image.asset(ImagePaths.dfaccount),
                            ),
                          ),
                      const SizedBox(width: 10),
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ] else
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                const SizedBox(width: 16),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.white, width: 0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:
                      isSelected
                          ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                          : null,
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.2), height: 1),
        ],
      ),
    );
  }
}
