import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wealthnxai/core/services/auth_service.dart';
import 'package:wealthnxai/core/services/biometric_service.dart';
import 'package:wealthnxai/core/services/image_picker_service.dart';
import 'package:wealthnxai/core/services/storage_service.dart';
import 'package:wealthnxai/domain/entities/user_entity/user_entity.dart';
import 'package:wealthnxai/domain/usecases/drawer/get_user_profile_usecase.dart';
import 'package:wealthnxai/domain/usecases/drawer/update_user_profile_usecase.dart';
import 'package:wealthnxai/presentation/widgets/loading/app_loading_widget.dart';
import 'package:wealthnxai/presentation/widgets/snackbar/app_snackbar.dart';

class UserProfileController extends GetxController {
  UserProfileController({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.authService,
  });

  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final AuthService authService;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();
  final dobController = TextEditingController();
  final addressController = TextEditingController();
  final socialLinkController = TextEditingController();
  final RxString profilePic = RxString('');
  String? gender;
  String? maritalStatus;

  final isLoading = false.obs;
  final RxString displayName = ''.obs;
  final RxString errorMessage = ''.obs;

  /// Holds the newly selected profile image file (from camera or gallery).
  /// This does NOT automatically upload; it is used when calling the update API.
  final Rxn<File> profileImageFile = Rxn<File>();

  // Helpers
  String get fullName => fullNameController.text;
  String get displayNameText => displayName.value;

  // Services
  StorageService storageService = StorageService.instance;
  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final BiometricService biometricService = BiometricService.instance;
  final ImagePickerService _imagePickerService = ImagePickerService.instance;

  /// Handle date of birth selection
  Future<void> selectDateOfBirth(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final month = twoDigits(picked.month);
      final day = twoDigits(picked.day);
      final year = picked.year % 100;
      dobController.text = '$month/$day/${twoDigits(year)}';
    }
  }

  /// Update gender from dropdown
  void setGender(String? value) {
    gender = value;
    update();
  }

  /// Update marital status from dropdown
  void setMaritalStatus(String? value) {
    maritalStatus = value;
    update();
  }

  ///on init
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserProfile();
    });
  }

  /// get user profile
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      Get.dialog(
        const Center(child: AppLoadingWidget()),
        barrierDismissible: false,
      );

      final result = await getUserProfileUseCase(NoParams());

      result.fold(
        (failure) {
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Error');
        },
        (profile) {
          Get.back();
          fullNameController.text = profile.fullName;
          firstNameController.text = profile.firstName;
          lastNameController.text = profile.lastName;
          emailController.text = profile.email;
          phoneNoController.text = profile.phoneNo;
          dobController.text = profile.dob;
          addressController.text = profile.address;
          gender = profile.gender;
          maritalStatus = profile.maritalState;
          socialLinkController.text = profile.socialLink;
          profilePic.value = profile.profilePic;

          // Keep local auth user in sync if available
          final existingUser = authService.currentUser;
          if (existingUser != null) {
            final updatedUser = existingUser.copyWith(
              name: profile.fullName,
              email: profile.email,
            );
            authService.setCurrentUser(updatedUser);
            currentUser.value = updatedUser;
            displayName.value = profile.fullName;
          }
          update();
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = 'An unexpected error occurred';
      AppSnackBar.showError(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    } finally {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      isLoading.value = false;
    }
  }

  /// Pick profile image from gallery and store it in [profileImageFile].
  Future<void> pickProfileImageFromGallery() async {
    final File? file = await _imagePickerService.pickImageFromGallery();
    if (file != null) {
      profileImageFile.value = file;
      // If your backend expects a path or base64 string, you can also update
      // [profilePicController] here accordingly.
      // profilePicController.text = file.path;
      update();
    }
    Get.back();
  }

  /// Capture profile image from camera and store it in [profileImageFile].
  Future<void> pickProfileImageFromCamera() async {
    final File? file = await _imagePickerService.pickImageFromCamera();
    if (file != null) {
      profileImageFile.value = file;
      // Optionally sync with `profilePicController` if needed by your API.
      // profilePicController.text = file.path;
      update();
    }
    Get.back();
  }

  /// update user profile
  Future<void> updateUserProfile() async {
    try {
      isLoading.value = true;
      Get.dialog(
        const Center(child: AppLoadingWidget()),
        barrierDismissible: false,
      );

      // Pass the selected image file directly (will be uploaded as multipart file)
      final File? profilePicFile = profileImageFile.value;

      final params = UpdateUserProfileParams(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phoneNo: phoneNoController.text.trim(),
        dob: dobController.text,
        address: addressController.text,
        gender: (gender ?? '').trim(),
        maritalState: (maritalStatus ?? '').trim(),
        profilePic: profilePicFile,
        socialLink: socialLinkController.text.trim(),
      );

      final result = await updateUserProfileUseCase(params);

      result.fold(
        (failure) {
          Get.back();
          AppSnackBar.showError(failure.message, title: 'Error');
        },
        (profile) async {
          Get.back();
          AppSnackBar.showSuccess(
            'Profile updated successfully',
            title: 'Success',
          );
print(" ${profile.body.profilePic}");
          fullNameController.text = profile.body.fullName;
          firstNameController.text = profile.body.firstName;
          lastNameController.text = profile.body.lastName;
          emailController.text = profile.body.email;
          phoneNoController.text = profile.body.phoneNo;
          dobController.text = profile.body.dob;
          addressController.text = profile.body.address;
          gender = profile.body.gender;
          maritalStatus = profile.body.maritalState;
          socialLinkController.text = profile.body.socialLink;
          profilePic.value = profile.body.profilePic;


          // Keep display name in sync after a successful update
          final combinedName =
              '${firstNameController.text} ${lastNameController.text}';
          displayName.value =
              combinedName.isNotEmpty ? combinedName : fullNameController.text;

          storageService.saveUserFullName(displayName.value);
          storageService.saveUserEmail(emailController.text);
          storageService.saveUserAvatar(profilePic.value);

          // Also update the global auth user so the whole app reflects new data
          final existingUser = authService.currentUser;
          if (existingUser != null) {
            final updatedUser = existingUser.copyWith(
              name: displayName.value,
              email: emailController.text,
              avatar: profilePic.value
            );
            await authService.setCurrentUser(updatedUser);
            await biometricService.updateBioEmail(emailController.text);
            currentUser.value = updatedUser;
          }
        },
      );
    } catch (e) {
      Get.back();
      errorMessage.value = 'An unexpected error occurred';
      AppSnackBar.showError(
        'An unexpected error occurred. Please try again.',
        title: 'Error',
      );
    } finally {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    dobController.dispose();
    addressController.dispose();
    socialLinkController.dispose();
    super.onClose();
  }
}
