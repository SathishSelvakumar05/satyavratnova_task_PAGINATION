import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestAll() async {
    await _requestLocation();
    await _requestNotification();
  }

  static Future<bool> _requestLocation() async {
    final status = await Permission.locationWhenInUse.request();
    return status.isGranted;
  }

  static Future<bool> _requestNotification() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> isLocationGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }
}