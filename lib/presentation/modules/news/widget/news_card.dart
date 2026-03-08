// /// News Card Widget
// /// Located in: lib/presentation/modules/news/widget/news_card.dart
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:wealthnxai/core/themes/app_spacing.dart';
// import 'package:wealthnxai/domain/entities/news_entity/news_entity.dart';
// import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
//
// class NewsCard extends StatelessWidget {
//   final String? imageUrl;
//   final String title;
//   final String? text;
//   final String source;
//   final String date;
//   final String? tag;
//   final bool isHorizontal;
//   final String? publishDate;
//   final String? url;
//   final bool showRelativeDate;
//   final String relativeText;
//   final double? width;
//   final double? imageHeight;
//
//   const NewsCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.source,
//     required this.date,
//     this.tag,
//     this.isHorizontal = false,
//     required this.publishDate,
//     this.showRelativeDate = false,
//     this.relativeText = '',
//     this.url,
//     this.text,
//     this.width,
//     this.imageHeight,
//   });
//
//   void _openNewsDetail() {
//     if (url == null || url!.isEmpty) return;
//
//     final controller = Get.find<NewsController>();
//
//     // Create NewsEntity from card data
//     final newsEntity = NewsEntity(
//       image: imageUrl,
//       title: title,
//       site: source,
//       publishedDate: publishDate ?? date,
//       url: url,
//       text: text,
//     );
//
//     // Use controller method - this sets selectedNews before navigation
//     controller.navigateToNewsDetail(newsEntity, tag: tag);
//   }
//
//   String formatDateWithRelative(String rawDate, String relativeText) {
//     try {
//       final d = DateTime.parse(rawDate).toLocal();
//       final formattedDate = "${d.month}-${d.day}-${d.year}";
//       if (relativeText.isEmpty) {
//         return formattedDate;
//       }
//       return formattedDate;
//     } catch (_) {
//       return relativeText;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double imgH = imageHeight ?? (isHorizontal ? 100 : 150);
//     final double imgW = isHorizontal ? 120 : double.infinity;
//
//     final imageWidget = ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child:
//           imageUrl != null && imageUrl!.isNotEmpty
//               ? CachedNetworkImage(
//                 imageUrl: imageUrl!,
//                 height: imgH,
//                 width: imgW,
//                 fit: BoxFit.cover,
//                 placeholder:
//                     (context, url) => Shimmer.fromColors(
//                       baseColor: Colors.grey.shade800,
//                       highlightColor: Colors.grey.shade600,
//                       child: Container(
//                         height: imgH,
//                         width: imgW,
//                         color: Colors.grey.shade800,
//                       ),
//                     ),
//                 errorWidget:
//                     (context, url, error) => Image.asset(
//                       'assets/images/Card.png',
//                       height: imgH,
//                       width: imgW,
//                       fit: BoxFit.cover,
//                     ),
//               )
//               : Image.asset(
//                 'assets/images/Card.png',
//                 height: imgH,
//                 width: imgW,
//                 fit: BoxFit.cover,
//               ),
//     );
//
//     final detailsWidget = Expanded(
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: isHorizontal ? 8 : 0,
//           top: isHorizontal ? 0 : 8,
//           right: 20,
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               // style: const TextStyle(
//               //   fontSize: 14,
//               //   fontWeight: FontWeight.w400,
//               //   color: Colors.white,
//               // ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Container(
//                   width: 25,
//                   height: 25,
//                   decoration: BoxDecoration(
//                     color: Colors.white.withOpacity(0.9),
//                     shape: BoxShape.circle,
//                   ),
//                   child: ClipOval(
//                     child: CachedNetworkImage(
//                       imageUrl:
//                           'https://www.google.com/s2/favicons?sz=64&domain_url=$source',
//                       fit: BoxFit.cover,
//                       placeholder:
//                           (context, url) => Shimmer.fromColors(
//                             baseColor: Colors.grey.shade700,
//                             highlightColor: Colors.grey.shade500,
//                             child: Container(
//                               width: 25,
//                               height: 25,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade700,
//                                 shape: BoxShape.circle,
//                               ),
//                             ),
//                           ),
//                       errorWidget:
//                           (context, url, error) => Image.asset(
//                             'assets/images/expensewallet.png',
//                             fit: BoxFit.cover,
//                           ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         source,
//                         style: const TextStyle(
//                           fontSize: 12,
//                           color: Colors.white70,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 20),
//                         child: Row(
//                           children: [
//                             Text(
//                               formatDateWithRelative(date, relativeText),
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.white54,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//
//     return GestureDetector(
//       onTap: _openNewsDetail,
//       child: Container(
//         width: width ?? (isHorizontal ? double.infinity : 250),
//         margin: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
//         child:
//             isHorizontal
//                 ? Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     detailsWidget,
//                     AppSpacing.addWidth(5),
//                     imageWidget,
//                   ],
//                 )
//                 : Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [imageWidget, detailsWidget],
//                 ),
//       ),
//     );
//   }
// }
/// News Card Widget
/// Located in: lib/presentation/modules/news/widget/news_card.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/domain/entities/news_entity/news_entity.dart';
import 'package:wealthnxai/presentation/modules/News/controller/news_controller.dart';
import 'package:wealthnxai/presentation/widgets/avator/app_avator.dart';

class NewsCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? text;
  final String source;
  final String date;
  final String? tag;
  final bool isHorizontal;
  final String? publishDate;
  final String? url;
  final bool showRelativeDate;
  final String relativeText;
  final double? width;
  final double? imageHeight;

  const NewsCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.source,
    required this.date,
    this.tag,
    this.isHorizontal = false,
    required this.publishDate,
    this.showRelativeDate = false,
    this.relativeText = '',
    this.url,
    this.text,
    this.width,
    this.imageHeight,
  });

  void _openNewsDetail() {
    if (url == null || url!.isEmpty) return;
    final controller = Get.find<NewsController>();
    final newsEntity = NewsEntity(
      image: imageUrl,
      title: title,
      site: source,
      publishedDate: publishDate ?? date,
      url: url,
      text: text,
    );
    controller.navigateToNewsDetail(newsEntity, tag: tag);
  }

  String formatDateWithRelative(String rawDate, String relativeText) {
    try {
      final d = DateTime.parse(rawDate).toLocal();
      final formattedDate = "${d.month}-${d.day}-${d.year}";
      return formattedDate;
    } catch (_) {
      return relativeText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double imgH = imageHeight ?? (isHorizontal ? 100 : 150);
    final double imgW = isHorizontal ? 120 : (width ?? double.infinity);

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AppImageAvatar(
        avatarUrl: imageUrl,
        fallbackAsset: 'assets/images/Card.png',
        isCircular: false,
        imageWidth: imgW == double.infinity ? null : imgW,
        imageHeight: imgH,
      //  borderWidth: 0,
      ),
    );

    final detailsWidget = Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: isHorizontal ? 8 : 0,
          top: isHorizontal ? 0 : 8,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                AppImageAvatar(
                  avatarUrl:
                  'https://www.google.com/s2/favicons?sz=64&domain_url=$source',
                  radius: 12.5,
                  fallbackAsset: 'assets/images/expensewallet.png',
                  borderWidth: 0,
                  borderColor: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        source,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          formatDateWithRelative(date, relativeText),
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: _openNewsDetail,
      child: Container(
        width: width ?? (isHorizontal ? double.infinity : 250),
        margin: const EdgeInsets.only(right: 8, bottom: 8, top: 8),
        child: isHorizontal
            ? Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailsWidget,
            AppSpacing.addWidth(5),
            imageWidget,
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [imageWidget, detailsWidget],
        ),
      ),
    );
  }
}