import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:codelab5/app/modules/home/controllers/home_controller.dart';

class LocationTrackerPage extends StatefulWidget {
  const LocationTrackerPage({super.key});

  @override
  State<LocationTrackerPage> createState() => _LocationTrackerPageState();
}

class _LocationTrackerPageState extends State<LocationTrackerPage> {
  final LocationController _controller = LocationController();
  Position? _currentPosition;
  String _locationMessage = "Location not found";
  bool _loading = false;

  void _setLoading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  void _setLocationMessage(String message) {
    setState(() {
      _locationMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 80,
                      color: Color.fromARGB(255, 243, 212, 33),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Current Location',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    _loading
                        ? const Center(child: CircularProgressIndicator())
                        : Text(
                            _locationMessage,
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.location_searching),
              label: const Text('Find Location'),
              onPressed: () async {
                _currentPosition = await _controller.getCurrentLocation(
                  context,
                  _setLoading,
                  _setLocationMessage,
                );
              },
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              icon: const Icon(Icons.map_outlined),
              label: const Text('Open Maps'),
              onPressed: () {
                _controller.openGoogleMaps(context, _currentPosition);
              },
            ),
          ],
        ),
      ),
    );
  }
}