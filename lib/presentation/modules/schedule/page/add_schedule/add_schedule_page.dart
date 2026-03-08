import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/constants/app_enums.dart';
import 'package:wealthnxai/core/themes/app_spacing.dart';
import 'package:wealthnxai/core/utils/validators.dart';
import 'package:wealthnxai/presentation/modules/schedule/page/add_schedule/controller/add_schedule_controller.dart';
import 'package:wealthnxai/presentation/widgets/appbar/appbar_widget.dart';
import 'package:wealthnxai/presentation/widgets/buttons/app_button_widget.dart';
import 'package:wealthnxai/presentation/widgets/text/custom_text_widget.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_bottom_sheet_textfield.dart';
import 'package:wealthnxai/presentation/widgets/text_field/app_textfield.dart';

class AddSchedulePage extends StatelessWidget {
  const AddSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddScheduleController>();
    final title =
        controller.formType == ScheduleFormType.edit
            ? 'Edit Schedule'
            : 'Add Schedule';

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingSymmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: controller.titleController,
                      label: "Title".tr,
                      keyboardType: TextInputType.name,
                      hintText: '',
                      textInputAction: TextInputAction.done,
                      validator: (value) => Validators.validateName(value),
                    ),
                    AppSpacing.addHeight(AppSpacing.sm),
                    AppTextField(
                      controller: controller.amountController,
                      label: "Amount".tr,
                      keyboardType: TextInputType.number,
                      hintText: '',
                      textInputAction: TextInputAction.done,
                    ),
                    AppSpacing.addHeight(AppSpacing.sm),
                    AppTextField(
                      controller: controller.dateController,
                      label: "Date".tr,
                      keyboardType: TextInputType.none,
                      hintText: 'MM/DD/YY',
                      readOnly: true,
                      onTap: () => controller.selectDate(context),
                      textInputAction: TextInputAction.done,
                      validator: (value) => Validators.validateDateTime(value),
                    ),
                    AppSpacing.addHeight(AppSpacing.sm),

                    AppText(txt: 'Frequency'.tr),
                    AppSpacing.addHeight(AppSpacing.sm),
                    Obx(
                      () => AppBottomSheetTextField<RecurrenceIntervalType>(
                        value: controller.recurrence.value,
                        items: RecurrenceIntervalType.values,
                        labelOf: (e) => controller.getRecurrenceLabel(e),
                        iconOf: null,
                        colorCategory: null,
                        onChanged: (v) => controller.setRecurrence(v),
                        validator: (v) => null,
                        placeholder: 'Select frequency',
                        allowDeselect: true,
                        showIcons: false,
                        title: 'Select Frequency',
                        description: 'Choose a frequency for your schedule',
                      ),
                    ),
                    AppSpacing.addHeight(AppSpacing.sm),
                    AppText(txt: 'Category'.tr),
                    AppSpacing.addHeight(AppSpacing.sm),
                    Obx(
                      () => AppBottomSheetTextField<String>(
                        value: controller.selectedCategory.value,
                        items: AddScheduleController.availableCategories,
                        labelOf: (c) => controller.getCategoryLabel(c),
                        iconOf: (c) => controller.getCategoryIcon(c),
                        colorCategory: (c) => controller.getCategoryColor(c),
                        onChanged: (v) => controller.setCategory(v),
                        validator: (v) => null,
                        placeholder: 'Select category',
                        allowDeselect: true,
                        showIcons: true,
                        title: 'Select Category',
                        description: 'Choose a category for your schedule',
                      ),
                    ),
                    AppSpacing.addHeight(AppSpacing.sm),
                    AppTextField(
                      controller: controller.descriptionController,
                      label: "Description".tr,
                      keyboardType: TextInputType.multiline,
                      hintText: 'Add details for this schedule…',
                      textInputAction: TextInputAction.done,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: AppButton(
            onTap: () {
              if (controller.formType == ScheduleFormType.edit) {
                controller.editSchedule();
              } else {
                controller.addSchedule();
              }
            },
            txt:
                controller.formType == ScheduleFormType.edit
                    ? 'Update'
                    : 'Save',
          ),
        ),
      ),
    );
  }
}
