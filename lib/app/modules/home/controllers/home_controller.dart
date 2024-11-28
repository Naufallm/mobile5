import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationController {
  Future<Position?> getCurrentLocation(
      BuildContext context, Function setLoading, Function setLocationMessage) async {
    setLoading(true);
    setLocationMessage("Searching for location...");

    try {
      // Check location service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Location services are disabled');
      }

      // Handle permissions using permission_handler
      PermissionStatus permissionStatus = await Permission.location.request();

      if (permissionStatus.isDenied) {
        throw Exception('Location permissions are denied');
      } else if (permissionStatus.isPermanentlyDenied) {
        openAppSettings();
        throw Exception('Location permissions are permanently denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setLocationMessage("Latitude: ${position.latitude}\nLongitude: ${position.longitude}");
      setLoading(false);
      return position;
    } catch (e) {
      setLoading(false);
      setLocationMessage('Failed to retrieve location');
      _showErrorDialog(context, e.toString());
      return null;
    }
  }

  void openGoogleMaps(BuildContext context, Position? position) {
    if (position != null) {
      final url = 'https://www.google.com/maps?q=${position.latitude},${position.longitude}';
      _launchURL(context, url);
    } else {
      _showErrorDialog(context, 'No location available. Please find location first.');
    }
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showErrorDialog(context, 'Could not launch maps');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
