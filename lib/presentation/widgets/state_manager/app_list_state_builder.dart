import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wealthnxai/presentation/widgets/state_manager/app_state_builder.dart';

/// A specialized widget for handling list states with shimmer loading
/// 
/// This widget extends AppStateBuilder with list-specific features:
/// - Shimmer loading for list items
/// - Empty list state
/// - Error state with retry
/// - Data list rendering
/// 
/// Example usage:
/// ```dart
/// AppListStateBuilder<Item>(
///   isLoading: controller.isLoading.value,
///   hasError: controller.errorMessage.value.isNotEmpty,
///   errorMessage: controller.errorMessage.value,
///   items: items,
///   loadingItemCount: 5,
///   loadingItemBuilder: (context, index) => ShimmerCard(),
///   emptyMessage: 'No items found',
///   errorTitle: 'Failed to load',
///   onRetry: () => controller.refresh(),
///   itemBuilder: (context, index, item) => ItemCard(item: item),
/// )
/// ```
class AppListStateBuilder<T> extends StatelessWidget {
  /// Whether the data is currently loading
  final bool isLoading;
  
  /// Whether there is an error
  final bool hasError;
  
  /// Error message to display
  final String? errorMessage;
  
  /// The list of items to display
  final List<T> items;
  
  /// Number of shimmer items to show while loading
  final int loadingItemCount;
  
  /// Builder for loading shimmer items
  final Widget Function(BuildContext context, int index)? loadingItemBuilder;
  
  /// Builder for actual list items
  final Widget Function(BuildContext context, int index, T item) itemBuilder;
  
  /// Optional callback for retry action
  final VoidCallback? onRetry;
  
  /// Custom empty message
  final String? emptyMessage;
  
  /// Custom error title
  final String? errorTitle;
  
  /// Scroll physics for the list
  final ScrollPhysics? physics;
  
  /// Whether to shrink wrap the list
  final bool shrinkWrap;
  
  /// Padding for the list
  final EdgeInsets? padding;
  
  /// Separator builder for list items
  final Widget Function(BuildContext context, int index)? separatorBuilder;

  const AppListStateBuilder({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.items,
    required this.itemBuilder,
    this.errorMessage,
    this.loadingItemCount = 5,
    this.loadingItemBuilder,
    this.onRetry,
    this.emptyMessage,
    this.errorTitle,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.separatorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AppStateBuilder<List<T>>(
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: errorMessage,
      isEmpty: items.isEmpty && !isLoading && !hasError,
      emptyMessage: emptyMessage ?? 'No items found',
      errorTitle: errorTitle,
      onRetry: onRetry,
      data: items,
      loadingWidget: _buildLoadingList(context),
      dataWidget: (data) => _buildDataList(context, data),
    );
  }

  Widget _buildLoadingList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.zero,
      itemCount: loadingItemCount,
      separatorBuilder: separatorBuilder ?? (_, __) => const SizedBox.shrink(),
      itemBuilder: loadingItemBuilder ?? _defaultLoadingItemBuilder,
    );
  }

  Widget _buildDataList(BuildContext context, List<T> data) {
    if (separatorBuilder != null) {
      return ListView.separated(
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding: padding ?? EdgeInsets.zero,
        itemCount: data.length,
        separatorBuilder: separatorBuilder!,
        itemBuilder: (context, index) {
          if (index >= 0 && index < data.length) {
            return itemBuilder(context, index, data[index]);
          }
          return const SizedBox.shrink();
        },
      );
    }
    
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? EdgeInsets.zero,
      itemCount: data.length,
      itemBuilder: (context, index) {
        if (index >= 0 && index < data.length) {
          return itemBuilder(context, index, data[index]);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _defaultLoadingItemBuilder(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.black,
        highlightColor: Colors.grey[700]!,
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
