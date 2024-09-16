import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BeachMap(), // Set BeachMap as the main screen
    );
  }
}

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
  final LatLngBounds _indiaBounds = LatLngBounds(
    southwest: LatLng(6.4622, 68.1100),
    northeast: LatLng(37.1044, 97.2394),
  );

  final LatLng _initialPosition = LatLng(20.5937, 78.9629); // Center of India
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  // List of beaches
  final List<Beach> beaches = [
    // Andhra Pradesh beaches
    Beach(name: 'Rushikonda Beach', position: LatLng(17.7833, 83.3883), snippet: 'Andhra Pradesh'),
    Beach(name: 'Bheemunipatnam Beach', position: LatLng(17.8924, 83.4520), snippet: 'Andhra Pradesh'),
    Beach(name: 'Manginapudi Beach', position: LatLng(16.1782, 81.1391), snippet: 'Andhra Pradesh'),
    Beach(name: 'Mypad Beach', position: LatLng(14.3623, 80.1417), snippet: 'Andhra Pradesh'),
    Beach(name: 'Vodarevu Beach', position: LatLng(15.8357, 80.3512), snippet: 'Andhra Pradesh'),
    // Goa beaches
    Beach(name: 'Colva Beach', position: LatLng(15.2793, 73.9220), snippet: 'Goa'),
    Beach(name: 'Dona Paula Beach', position: LatLng(15.4667, 73.8333), snippet: 'Goa'),
    Beach(name: 'Anjuna Beach', position: LatLng(15.5819, 73.7432), snippet: 'Goa'),
    Beach(name: 'Arambol Beach', position: LatLng(15.6869, 73.7046), snippet: 'Goa'),
    // Gujarat beaches
    Beach(name: 'Porbandar Beach', position: LatLng(21.6421, 69.6293), snippet: 'Gujarat'),
    Beach(name: 'Mandvi Beach', position: LatLng(22.8327, 69.3460), snippet: 'Gujarat'),
    Beach(name: 'Somnath Beach', position: LatLng(20.8880, 70.4017), snippet: 'Gujarat'),
    Beach(name: 'Chorwad Beach', position: LatLng(21.0169, 70.2166), snippet: 'Gujarat'),
    // More beaches can be added here
  ];


  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  void _addMarkers() {
    setState(() {
      _markers.clear();
      for (var beach in beaches) {
        _markers.add(
          Marker(
            markerId: MarkerId(beach.name),
            position: beach.position,
            infoWindow: InfoWindow(
              title: beach.name,
              snippet: beach.snippet,
            ),
          ),
        );
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(_indiaBounds, 10));
  }

  void _onSearchPressed() {
    setState(() {
      _isSearching = !_isSearching; // Toggle search bar visibility
    });
  }

  void _onSearch() {
    // Implement your search functionality here
    // For example, you can show an alert dialog with search results
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Result'),
          content: Text('Search functionality to be implemented'),
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
            zoomControlsEnabled: false, // Remove the zoom controls
            onTap: (LatLng position) {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                });
              }
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: _isSearching ? MediaQuery.of(context).size.width - 32 : 56, // Expand to the end of the screen
                  height: 48,
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _isSearching
                            ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: (value) {
                              _onSearch();
                            },
                            style: TextStyle(color: Colors.white), // Change text color to white
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.white54), // Optional: Change hint text color to light white
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                            ),
                          ),
                        )
                            : Container(),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.white),
                        onPressed: _onSearchPressed,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
