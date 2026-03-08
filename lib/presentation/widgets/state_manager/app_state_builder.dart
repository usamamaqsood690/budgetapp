import 'package:flutter/material.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';

/// A powerful reusable widget that handles loading, error, empty, and data states
///
/// This widget provides a clean way to manage different states of your data:
/// - isLoading: Shows loading widget
/// - hasError: Shows error widget with optional retry
/// - isEmpty: Shows empty widget
/// - hasData: Shows data widget
///
/// Example usage:
/// ```dart
/// AppStateBuilder<List<Item>>(
///   isLoading: controller.isLoading.value,
///   hasError: controller.errorMessage.value.isNotEmpty,
///   errorMessage: controller.errorMessage.value,
///   isEmpty: items.isEmpty,
///   emptyWidget: const EmptyStateWidget(message: 'No items found'),
///   loadingWidget: const AppLoadingWidget(),
///   errorWidget: ErrorStateWidget(
///     message: controller.errorMessage.value,
///     onRetry: () => controller.refresh(),
///   ),
///   data: items,
///   dataWidget: (items) => ListView.builder(...),
/// )
/// ```
class AppStateBuilder<T> extends StatelessWidget {
  /// Whether the data is currently loading
  final bool isLoading;

  /// Whether there is an error
  final bool hasError;

  /// Error message to display
  final String? errorMessage;

  /// Whether the data is empty
  final bool isEmpty;

  /// Widget to show when loading
  final Widget? loadingWidget;

  /// Widget to show when there's an error
  final Widget? errorWidget;

  /// Widget to show when data is empty
  final Widget? emptyWidget;

  /// The data to display
  final T? data;

  /// Builder function that receives the data and returns a widget
  final Widget Function(T data) dataWidget;

  /// Optional callback for retry action
  final VoidCallback? onRetry;

  /// Custom empty message
  final String? emptyMessage;

  /// Custom error title
  final String? errorTitle;

  /// Whether to show loading even when there's data (for refresh scenarios)
  final bool showLoadingOverlay;

  const AppStateBuilder({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.isEmpty,
    required this.dataWidget,
    this.errorMessage,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.data,
    this.onRetry,
    this.emptyMessage,
    this.errorTitle,
    this.showLoadingOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (isLoading && !showLoadingOverlay) {
      return loadingWidget ?? const AppLoadingWidget();
    }

    // Show error state
    if (hasError && !isLoading) {
      return errorWidget ??
          ErrorStateWidget(
            message: errorMessage ?? 'An error occurred',
            title: errorTitle,
            onRetry: onRetry,
          );
    }

    // Show empty state
    if (isEmpty && !isLoading && !hasError) {
      return emptyWidget ??
          EmptyStateWidget(message: emptyMessage ?? 'No data available');
    }

    // Show data with optional loading overlay
    if (data != null) {
      final content = dataWidget(data as T);

      if (showLoadingOverlay && isLoading) {
        return Stack(
          children: [
            content,
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(child: loadingWidget ?? const AppLoadingWidget()),
            ),
          ],
        );
      }

      return content;
    }

    // Fallback to empty state if no data
    return emptyWidget ??
        EmptyStateWidget(message: emptyMessage ?? 'No data available');
  }
}

/// Empty state widget
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, const SizedBox(height: 16)],
            Text(
              message,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;
  final Widget? icon;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(height: 16),
            ] else ...[
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
            ],
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ],
        ),
      ),
    );
  }
}
