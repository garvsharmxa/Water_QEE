import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActionButton extends StatefulWidget {
  const ActionButton({super.key});

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Show the dropdown menu with the map type options
              showMenu<String>(
                context: context,
                position: RelativeRect.fromLTRB(
                    16.0, MediaQuery.of(context).size.height - 200, 0, 0),
                items: _mapTypes.keys.map<PopupMenuEntry<String>>((String value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    _selectedMapType = value;
                  });
                }
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Set background color for button
            ),
            child: const Icon(Icons.map, color: Colors.white), // Set icon color for button
          ),
        ],
      ),
    );
  }
}
