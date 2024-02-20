import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  List<LatLng> _polygonPoints = [];
  bool _mapReady = false;
  String _selectedMapType = 'normal';
  TextEditingController _searchController = TextEditingController();
  bool _polygonDrawingMode = false;
  LatLng _currentLocation = LatLng(0, 0); // Initial position

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  void _initMap() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denied permission
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Location Permission Denied'),
              content: const Text('Please grant location permission in settings to use this feature.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _mapReady = true;
      if (_mapController != null) {
        _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _currentLocation,
            zoom: 10.0,
          ),
        ));

        // Clear the markers and add a new marker for the current location
        _markers.clear();
        _markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: _currentLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Icon for live location
          ),
        );
      }
    });
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _polygonPoints.add(latLng);
      _markers.add(
        Marker(
          markerId: MarkerId(latLng.toString()),
          position: latLng,
        ),
      );
      _polygons.add(
        Polygon(
          polygonId: const PolygonId('roi_polygon_${3}'),
          points: _polygonPoints,
          strokeWidth: 2,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withOpacity(0.2),
        ),
      );
    });
  }

  void _searchLocation() async {
    String searchText = _searchController.text;
    List<Location> locations;

    try {
      locations = await locationFromAddress(searchText);
    } catch (e) {
      // Handle the exception here
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
              'Could not find any result for the supplied address or coordinates.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    if (locations.isNotEmpty) {
      Location location = locations.first;
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(location.latitude, location.longitude),
        10.0,
      ));

      setState(() {
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(location.toString()),
            position: LatLng(location.latitude, location.longitude),
          ),
        );
      });
    }
  }

  Map<String, MapType> _mapTypes = {
    'normal': MapType.normal,
    'satellite': MapType.satellite,
    'terrain': MapType.terrain,
    'hybrid': MapType.hybrid,
  };

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Map Screen')),
      body: _mapReady
          ? Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: _polygonDrawingMode ? _onMapTap : null,
            markers: _markers,
            polygons: _polygons,
            mapType: _mapTypes[_selectedMapType]!,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 10.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 16,
                  right: 150,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search location...',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: _searchLocation,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 16,
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: DropdownButton<String>(
                        value: _selectedMapType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMapType = newValue!;
                          });
                        },
                        items: _mapTypes.keys.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: false,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _polygonDrawingMode = !_polygonDrawingMode;
                        if (!_polygonDrawingMode) {
                          _polygonPoints.clear();
                          _markers.clear();
                        }
                      });
                    },
                    child: Text(_polygonDrawingMode ? 'Cancel' : 'Add Polygon'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: null, // No action for this button
                    child: DropdownButton<String>(
                      value: 'none',
                      onChanged: (String? newValue) {
                        if (newValue == 'add') {
                          // Add Polygon action
                          setState(() {
                            _polygonDrawingMode = true;
                            _polygonPoints.clear();
                            _markers.clear();
                          });
                        } else if (newValue == 'remove') {
                          // Remove Polygon action
                          setState(() {
                            _polygons.removeWhere((polygon) => polygon.points == _polygonPoints);
                            _markers.removeWhere((marker) => _polygonPoints.contains(marker.position));
                            _polygonPoints.clear();
                          });
                        }
                      },
                      items: const [
                        DropdownMenuItem<String>(
                          value: 'none',
                          child: Text('Select an action'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'add',
                          child: Text('Add Polygon'),
                        ),
                        DropdownMenuItem<String>(
                          value: 'remove',
                          child: Text('Remove Polygon'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
      floatingActionButton: _mapReady
          ? FloatingActionButton(
        onPressed: () {
          // Add a marker at the current location
          _markers.add(
            Marker(
              markerId: const MarkerId('my_location_marker'),
              position: _currentLocation,
              infoWindow: const InfoWindow(
                title: 'My Location',
              ),
            ),
          );
          setState(() {});

          // Move the camera to the current location
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: _currentLocation,
                zoom: 15.0,
              ),
            ),
          );
        },
        child: const Icon(Icons.my_location),
      )
          : null, // Hide the button until the map is ready
    );
  }
}
