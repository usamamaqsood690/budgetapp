import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Image Picker Service
///
/// Centralised place to:
/// - Ask for camera / gallery permissions
/// - Open camera or gallery
/// - Return a `File` that you can store in your controller
class ImagePickerService {
  ImagePickerService._internal();
  static final ImagePickerService instance = ImagePickerService._internal();

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery after requesting the proper permission.
  Future<File?> pickImageFromGallery() async {
    final hasPermission = await _requestGalleryPermission();
    if (!hasPermission) return null;

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  /// Pick image from camera after requesting the proper permission.
  Future<File?> pickImageFromCamera() async {
    final hasPermission = await _requestCameraPermission();
    if (!hasPermission) return null;

    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }

  /// Request gallery / photo permission in a platform-safe, platform‑specific way.
  Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ (API 33+) uses photos permission
      if (await _isAndroid13OrAbove()) {
        var status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
        return status.isGranted;
      } else {
        // Android 12 and below uses storage permission
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
      return status.isGranted;
    }
    return true;
  }

  Future<bool> _isAndroid13OrAbove() async {
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSdkVersion();
      return sdkInt >= 33;
    }
    return false;
  }

  Future<int> _getAndroidSdkVersion() async {
    final info = await DeviceInfoPlugin().androidInfo;
    return info.version.sdkInt;
  }

  /// Request camera permission.
  Future<bool> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    return status.isGranted;
  }
}
