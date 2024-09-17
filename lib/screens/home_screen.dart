import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:beach1/screens/beach_details_screen.dart';

class Beach {
  final String name;
  final LatLng position;
  final String snippet;

  Beach({required this.name, required this.position, required this.snippet});
}

class BeachMap extends StatefulWidget {
  @override
  _BeachMapState createState() => _BeachMapState();
}

class _BeachMapState extends State<BeachMap> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = Set<Marker>();
  Set<Polygon> _polygons = Set<Polygon>();
  MarkerId? _selectedMarkerId;
  final LatLngBounds _indiaBounds = LatLngBounds(
    southwest: LatLng(6.4622, 68.1100),
    northeast: LatLng(37.1044, 97.2394),
  );

  final LatLng _initialPosition = LatLng(20.5937, 78.9629); // Center of India
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  List<Beach> _filteredBeaches = [];

  // List of beaches
  final List<Beach> beaches = [
    Beach(name: 'Juhu Beach', position: LatLng(19.0896, 72.8347), snippet: 'Mumbai, Maharashtra'),
    Beach(name: 'Marina Beach', position: LatLng(13.0481, 80.2714), snippet: 'Chennai, Tamil Nadu'),
    Beach(name: 'Goa Beach', position: LatLng(15.2993, 74.1240), snippet: 'Goa'),
    Beach(name: 'Kovalam Beach', position: LatLng(8.4000, 76.9960), snippet: 'Kerala'),
    // Add more beaches as needed
  ];

  @override
  void initState() {
    super.initState();
    _addMarkers();
    _addPolygons();
  }

  void _addMarkers() {
    setState(() {
      _markers.clear();
      for (var beach in beaches) {
        _markers.add(
          Marker(
            markerId: MarkerId(beach.name),
            position: beach.position,
            icon: _selectedMarkerId == MarkerId(beach.name)
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                : BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(
              title: beach.name,
              snippet: beach.snippet,
            ),
            onTap: () {
              _onMarkerTapped(beach);
            },
          ),
        );
      }
    });
  }

  void _addPolygons() {
    final random = Random();
    setState(() {
      _polygons.clear();
      for (var beach in beaches) {
        final color = [Colors.red, Colors.green, Colors.yellow][random.nextInt(3)];
        final polygonPoints = _generatePolygonPoints(beach.position);
        _polygons.add(
          Polygon(
            polygonId: PolygonId(beach.name),
            points: polygonPoints,
            strokeColor: Colors.black,
            strokeWidth: 2,
            fillColor: color.withOpacity(0.7),
          ),
        );
      }
    });
  }

  List<LatLng> _generatePolygonPoints(LatLng center) {
    const double offset = 1.0;
    return [
      LatLng(center.latitude + offset, center.longitude - offset),
      LatLng(center.latitude + offset, center.longitude + offset),
      LatLng(center.latitude - offset, center.longitude + offset),
      LatLng(center.latitude - offset, center.longitude - offset),
    ];
  }

  void _onMarkerTapped(Beach beach) {
    setState(() {
      _selectedMarkerId = MarkerId(beach.name);
      _addMarkers(); // Rebuild markers to apply color changes
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(beach.position, 12.0),
      );
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BeachDetailsScreen(
          beachName: beach.name,
          safetyStatus: 'Unsafe', // Example data
          tideStatus: 'High Tide', // Example data
          timings: '9:00 AM - 6:00 PM', // Example data
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(_indiaBounds, 10),
    );
  }

  void _onSearchPressed() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus(); // Request focus to keep the keyboard open
      }
    });
  }

  void _searchBeaches(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredBeaches = beaches.where((beach) {
        return beach.name.toLowerCase().contains(lowerCaseQuery);
      }).toList();
      if (_filteredBeaches.isEmpty) {
        _showBeachNotFoundDialog();
      }
    });
  }

  void _showBeachNotFoundDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('No Results Found'),
          content: Text('No beaches match the search query.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus(); // Hide the keyboard
  }

  void _showMenuOption(String option) {
    Color dialogBackgroundColor;

    switch (option) {
      case 'Feedback':
        dialogBackgroundColor = Colors.deepPurple[200]!;
        break;
      case 'Alerts':
        dialogBackgroundColor = Colors.deepPurple[200]!;
        break;
      case 'Recommendations':
        dialogBackgroundColor = Colors.deepPurple[200]!;
        break;
      case 'Favorites':
        dialogBackgroundColor = Colors.deepPurple[200]!;
        break;
      default:
        dialogBackgroundColor = Colors.white;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: dialogBackgroundColor,
          title: Text(option),
          content: option == 'Alerts'
              ? Text('Here are the current alerts...')
              : option == 'Feedback'
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Enter your feedback'),
                maxLines: 3,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Handle feedback submission
                },
                child: Text('Submit'),
              ),
            ],
          )
              : Text('Other content based on the option selected.'),
          actions: [
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 5.0,
            ),
            markers: _markers,
            polygons: _polygons,
            zoomControlsEnabled: false,
            onTap: (LatLng position) {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                });
              }
              _hideKeyboard(); // Hide the keyboard when tapping outside
            },
          ),
          if (_isSearching) ...[
            Positioned(
              top: 40,
              left: 16,
              right: 16,
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search for beaches...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.deepPurple[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _filteredBeaches.clear();
                        _isSearching = false;
                      });
                      _hideKeyboard(); // Hide the keyboard
                    },
                  ),
                ),
                onChanged: _searchBeaches,
              ),
            ),
          ],
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: _onSearchPressed,
                  child: Icon(_isSearching ? Icons.close : Icons.search),
                ),
                SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () => _showMenuOption('Feedback'),
                  child: Icon(Icons.chat_bubble_sharp),
                ),
                SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () => _showMenuOption('Alerts'),
                  child: Icon(Icons.warning),
                ),
                SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () => _showMenuOption('Recommendations'),
                  child: Icon(Icons.lightbulb),
                ),
                SizedBox(height: 16),
                FloatingActionButton(
                  onPressed: () => _showMenuOption('Favorites'),
                  child: Icon(Icons.favorite),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
