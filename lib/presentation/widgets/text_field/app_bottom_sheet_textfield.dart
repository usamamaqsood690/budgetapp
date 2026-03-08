import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/themes/app_color_schema.dart';
import 'package:wealthnxai/core/themes/app_dimensions.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_radio_button.dart';
import 'package:wealthnxai/presentation/widgets/divider/app_divider.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';

class AppBottomSheetTextField<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String Function(T) labelOf;
  final IconData Function(T)? iconOf;
  final Color Function(T)? colorCategory;
  final ValueChanged<T?> onChanged;
  final FormFieldValidator<T?>? validator;
  final InputDecoration? decoration;
  final String? placeholder;
  final bool allowDeselect;
  final bool showIcons;
  final String? title;
  final String? description;

  const AppBottomSheetTextField({
    super.key,
    required this.value,
    required this.items,
    required this.labelOf,
    required this.onChanged,
    required this.colorCategory,
    this.iconOf,
    this.validator,
    this.decoration,
    this.placeholder,
    this.allowDeselect = false,
    this.showIcons = false,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      initialValue: value,
      validator: validator,
      builder: (state) {
        final bool isEmpty = state.value == null;
        final String text =
        isEmpty ? (placeholder ?? 'Select') : labelOf(state.value as T);

        return InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () async {
            final picked = await _showPicker<T>(
              context: context,
              items: items,
              current: state.value,
              labelOf: labelOf,
              iconOf: showIcons ? iconOf : null,
              categoryColor: colorCategory,
              allowDeselect: allowDeselect,
              title: title,
              description: description,
            );
            state.didChange(picked);
            onChanged(picked);
          },
          child: InputDecorator(
            decoration: decoration ??
                InputDecoration(
                  hintText: placeholder,
                  suffixIcon: Icon(Icons.arrow_drop_down, color: context.colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: context.colors.onSurface,
                      width: AppDimensions.borderWidthThin,
                    ),
                    borderRadius: AppDimensions.borderRadiusMD,
                  ),
                ),
            child: AppText(txt: text),
          ),
        );
      },
    );
  }
}

// ─── Picker Bottom Sheet ─────────────────────────────────────────────────────

Future<T?> _showPicker<T>({
  required BuildContext context,
  required List<T> items,
  required T? current,
  required String Function(T) labelOf,
  IconData Function(T)? iconOf,
  Color Function(T)? categoryColor,
  String? title,
  String? description,
  bool allowDeselect = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    isScrollControlled: true,
    builder: (ctx) {
      return Container(
        height: Get.height * 0.7,
        padding: AppSpacing.paddingSymmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: context.colors.black,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(
              color: context.colors.grey,
              width: AppDimensions.borderWidthThin,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 56,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            AppSpacing.addHeight(AppSpacing.lg),

            // Title & description
            if (title != null || description != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title != null)
                      AppText(txt: title, style: ctx.textTheme.titleLarge),
                    if (description != null) ...[
                      AppSpacing.addHeight(AppSpacing.xs),
                      AppText(txt: description, style: ctx.textTheme.bodyMedium),
                    ],
                  ],
                ),
              ),

            AppSpacing.addHeight(AppSpacing.sm),

            // List
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.paddingSymmetric(vertical: AppSpacing.sm),
                itemCount: items.length,
                separatorBuilder: (_, __) => const AppDivider(),
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  final selected = current != null && item == current;

                  return ListTile(
                    contentPadding:AppSpacing.paddingZero(),
                    leading: iconOf != null
                        ?
                    CircleAvatar(
                      backgroundColor: categoryColor?.call(item),
                      child: Icon(iconOf(item), size: AppDimensions.iconXXL, color: context.colors.white),
                    )
                        : null,
                    title: AppText(txt: labelOf(item)),
                    trailing: AppRadioButton(
                      selected: selected,
                      onTap: () {
                        if (allowDeselect && selected) {
                          Navigator.of(ctx).pop(null);
                        } else {
                          Navigator.of(ctx).pop(item);
                        }
                      },
                    ),
                    onTap: () {
                      if (allowDeselect && selected) {
                        Navigator.of(ctx).pop(null);
                      } else {
                        Navigator.of(ctx).pop(item);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}