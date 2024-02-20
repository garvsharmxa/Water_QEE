import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMaps extends StatefulWidget {
  const GoogleMaps({super.key});

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {

  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polygon> _polygons = {};
  List<LatLng> _polygonPoints = [];
  String _selectedMapType = 'normal'; // Default map type

  // Define map types (styles)
  final Map<String, MapType> _mapTypes = {
    'normal': MapType.normal,
    'satellite': MapType.satellite,
    'terrain': MapType.terrain,
    'hybrid': MapType.hybrid,
  };

  @override
  Widget build(BuildContext context) {
    return  GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
      },
      onTap: _onMapTap,
      markers: _markers,
      polygons: _polygons,
      mapType: _mapTypes[_selectedMapType]!,
      initialCameraPosition: const CameraPosition(
        target: LatLng(0, 0),
        zoom: 12.0,
      ),
      zoomControlsEnabled:
      false, // Hide the default zoom controls of Google Maps
      myLocationEnabled: true, // Show the "My Location" button on the map
      myLocationButtonEnabled: false, // Hide the default "My Location" button
    );
  }
  void _onMapTap(LatLng latLng) {
    setState(() {
      if (_polygonPoints.isEmpty || _polygonPoints.length < 3) {
        _polygonPoints.add(latLng);
        _markers.add(
          Marker(
            markerId: MarkerId(latLng.toString()),
            position: latLng,
          ),
        );
        if (_polygonPoints.length >= 3) {
          _polygons.add(
            Polygon(
              polygonId: PolygonId('roi_polygon_${_polygons.length}'),
              points: _polygonPoints,
              strokeWidth: 2,
              strokeColor: Colors.blue,
              fillColor: Colors.blue.withOpacity(0.2),
            ),
          );
        }
      } else {
        // Start a new ROI
        _polygonPoints.clear();
        _markers.clear();
        _polygons.clear();
      }
    });
  }
}
