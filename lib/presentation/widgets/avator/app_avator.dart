import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';

class AppImageAvatar extends StatelessWidget {
  final double radius;
  final String? avatarUrl;
  final String fallbackAsset;
  final Color? borderColor;
  final double? borderWidth;
  final bool isCircular;
  final double? imageWidth;
  final double? imageHeight;
  final Widget? child;
  final Color? backgroundColor;
  final bool investmentIcon;

  const AppImageAvatar({
    super.key,
    this.avatarUrl,
     this.radius = 0,
    required this.fallbackAsset,
    this.borderColor,
    this.borderWidth,
    this.isCircular = true,
    this.imageHeight,
    this.imageWidth,
    this.child,
    this.backgroundColor,
    this.investmentIcon = false
  });

  bool _isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;
    return uri.scheme == 'http' || uri.scheme == 'https';
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl = _isValidImageUrl(avatarUrl);

    return Container(
      decoration: BoxDecoration(
        color:backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor ?? context.colors.transparent,
          width: AppDimensions.borderWidthThin,
        ),
      ),
      child:
          isCircular
              ? _buildCircularAvatar(hasUrl, context)
              : SizedBox(
                width: imageWidth ?? AppDimensions.radiusXXL,
                height: imageHeight ?? AppDimensions.radiusXXL,
                child: _buildImage(hasUrl, context),
              ),
    );
  }

  // ─── Circular Avatar ────────────────────────────────────────────────────────

  Widget _buildCircularAvatar(bool hasUrl, BuildContext context) {
    if (!hasUrl) {
      return _buildFallbackCircle(context);
    }

    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(avatarUrl!),
      builder: (context, snapshot) {
        // Loading
        if (snapshot.connectionState != ConnectionState.done) {
          return CircleAvatar(
            radius: radius,
            backgroundColor: context.colors.transparent,
            child: const CupertinoActivityIndicator(),
          );
        }

        // Error
        if (snapshot.hasError) {
          return _buildFallbackCircle(context);
        }

        // No data
        if (!snapshot.hasData) {
          return _buildFallbackCircle(context);
        }

        // Success
        final file = snapshot.data!;
        return Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:investmentIcon?context.colors.transparent : context.colorScheme.onPrimary
          ),
          child: ClipOval(
            child: Image.file(
              file,
              fit: BoxFit.cover,
              errorBuilder: (_, error, __) {
                return _buildFallbackCircle(context);
              },
            ),
          ),
        );
      },
    );
  }

  // ─── Fallback Circle ────────────────────────────────────────────────────────

  Widget _buildFallbackCircle(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius * 2,
        height: radius * 2,
        color: context.colors.transparent,
        padding: EdgeInsets.all(radius * 0.2),
        child: Image.asset(
          fallbackAsset,
          fit: BoxFit.contain,
          errorBuilder: (_, error, __) {
            return _buildDefaultIcon(context);
          },
        ),
      ),
    );
  }

  // ─── Non-Circular Image ─────────────────────────────────────────────────────

  Widget _buildImage(bool hasUrl, BuildContext context) {
    if (!hasUrl) {
      return Image.asset(
        fallbackAsset,
        fit: BoxFit.contain,
        errorBuilder: (_, error, __) {
          return _buildDefaultIcon(context);
        },
      );
    }

    final w = (imageWidth ?? AppDimensions.radiusXXL).toInt();
    final h = (imageHeight ?? AppDimensions.radiusXXL).toInt();

    return CachedNetworkImage(
      imageUrl: avatarUrl!,
      fit: BoxFit.cover,
      memCacheWidth: w,
      memCacheHeight: h,
      maxWidthDiskCache: w,
      maxHeightDiskCache: h,
      fadeInDuration: const Duration(milliseconds: 200),
      fadeOutDuration: const Duration(milliseconds: 100),
      placeholder: (_, url) {
        return const Center(child: CupertinoActivityIndicator());
      },
      imageBuilder: (_, imageProvider) {
        return Image(image: imageProvider, fit: BoxFit.cover);
      },
      errorWidget: (_, url, error) {
        return Image.asset(
          fallbackAsset,
          fit: BoxFit.contain,
          errorBuilder: (_, error, __) {
            return _buildDefaultIcon(context);
          },
        );
      },
    );
  }

  // ─── Default Icon ───────────────────────────────────────────────────────────

  Widget _buildDefaultIcon(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.colors.grey,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: radius,
        color: Colors.grey,
      ),
    );
  }
}
