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

  final List<Beach> beaches = [
    Beach(name: 'Juhu Beach', position: LatLng(19.0896, 72.8347), snippet: 'Mumbai, Maharashtra'),
    Beach(name: 'Marina Beach', position: LatLng(13.0481, 80.2714), snippet: 'Chennai, Tamil Nadu'),
    Beach(name: 'Goa Beach', position: LatLng(15.2993, 74.1240), snippet: 'Goa'),
    Beach(name: 'Kovalam Beach', position: LatLng(8.4000, 76.9960), snippet: 'Kerala'),
    Beach(name: 'Radhanagar Beach', position: LatLng(11.9835, 92.9876), snippet: 'Havelock Island, Andaman and Nicobar Islands'),
    Beach(name: 'Baga Beach', position: LatLng(15.5527, 73.7517), snippet: 'North Goa, Goa'),
    Beach(name: 'Varkala Beach', position: LatLng(8.7379, 76.6984), snippet: 'Thiruvananthapuram, Kerala'),
    Beach(name: 'Palolem Beach', position: LatLng(15.0090, 74.0233), snippet: 'South Goa, Goa'),
    Beach(name: 'Tarkarli Beach', position: LatLng(16.0370, 73.4673), snippet: 'Sindhudurg, Maharashtra'),
    Beach(name: 'Gokarna Beach', position: LatLng(14.5500, 74.3180), snippet: 'Uttara Kannada, Karnataka'),
    Beach(name: 'Bheemunipatnam Beach', position: LatLng(17.8901, 83.4473), snippet: 'Visakhapatnam, Andhra Pradesh'),
    Beach(name: 'Puri Beach', position: LatLng(19.7980, 85.8245), snippet: 'Puri, Odisha'),
    Beach(name: 'Dhanushkodi Beach', position: LatLng(9.1670, 79.4294), snippet: 'Rameswaram, Tamil Nadu'),
    Beach(name: 'Mandarmani Beach', position: LatLng(21.6686, 87.7071), snippet: 'East Midnapore, West Bengal'),
    Beach(name: 'Alappuzha Beach', position: LatLng(9.4981, 76.3388), snippet: 'Alappuzha, Kerala'),
    Beach(name: 'Elephant Beach', position: LatLng(12.0033, 93.0001), snippet: 'Havelock Island, Andaman and Nicobar Islands'),
    Beach(name: 'Diu Beach', position: LatLng(20.7146, 70.9874), snippet: 'Diu, Daman and Diu'),
    Beach(name: 'Rishikonda Beach', position: LatLng(17.7829, 83.3842), snippet: 'Visakhapatnam, Andhra Pradesh'),
    Beach(name: 'Auroville Beach', position: LatLng(12.0140, 79.8561), snippet: 'Pondicherry, Tamil Nadu'),
    Beach(name: 'Murud Beach', position: LatLng(18.3217, 72.9650), snippet: 'Raigad, Maharashtra'),
    Beach(name: 'Kapu Beach', position: LatLng(13.2313, 74.7353), snippet: 'Udupi, Karnataka'),
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
    const double offset = 0.2;
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

  void _fitBeachInView(Beach beach) {
    final padding = 50.0;
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(beach.position.latitude - 0.01, beach.position.longitude - 0.01),
      northeast: LatLng(beach.position.latitude + 0.01, beach.position.longitude + 0.01),
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, padding),
    );
  }

  void _onSearchPressed() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _filteredBeaches.clear();
      }
    });
  }

  void _searchBeaches(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      _filteredBeaches = beaches.where((beach) {
        return beach.name.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  void _hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _searchFocusNode.hasFocus ? MediaQuery.of(context).size.height / 2 : 56,
        decoration: BoxDecoration(
          color: Colors.deepPurple[200],
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'Search for beaches...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _filteredBeaches.clear();
                      _searchFocusNode.unfocus();
                    });
                  },
                ),
              ),
              onChanged: _searchBeaches,
            ),
            if (_searchFocusNode.hasFocus && _filteredBeaches.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredBeaches.length,
                  itemBuilder: (context, index) {
                    final beach = _filteredBeaches[index];
                    return ListTile(
                      title: Text(beach.name),
                      subtitle: Text(beach.snippet),
                      onTap: () {
                        _fitBeachInView(beach);
                        setState(() {
                          _isSearching = false;
                          _filteredBeaches.clear();
                        });
                        _hideKeyboard();
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
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
              : option == 'Favorites'
              ? Text('Here your favourite beaches will appear')
              : option == 'Recommendations'
              ? Text('Here your recommendations will occur')
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
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 5.0,
            ),
            markers: _markers,
            polygons: _polygons,
            onMapCreated: _onMapCreated,
          ),
          _buildSearchBar(),

          // Add the index with updated colors and labels here, above the Google logo
          Positioned(
            bottom: 40, // Set it above the Google logo
            left: 10, // You can adjust the left/right position as needed
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Green (Safe)
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.green, // Green color for 'Safe'
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Safe',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Yellow (Cautious)
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.yellow, // Yellow color for 'Cautious'
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Cautious',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Red (Dangerous)
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        color: Colors.red, // Red color for 'Dangerous'
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Dangerous',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 10,
            right: 10,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _showMenuOption('Alerts');
                  },
                  backgroundColor: Colors.deepPurple[200],
                  child: Icon(Icons.warning),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _showMenuOption('Recommendations');
                  },
                  backgroundColor: Colors.deepPurple[200],
                  child: Icon(Icons.lightbulb),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _showMenuOption('Favorites');
                  },
                  backgroundColor: Colors.deepPurple[200],
                  child: Icon(Icons.favorite),
                ),
                SizedBox(height: 10),
                FloatingActionButton(
                  onPressed: () {
                    _showMenuOption('Feedback');
                  },
                  backgroundColor: Colors.deepPurple[200],
                  child: Icon(Icons.feedback_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }




}
// Helper function to create the index box with color and label
Widget _buildIndexBox(Color color, String label) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        color: color,
      ),
      SizedBox(width: 5),
      Text(label, style: TextStyle(fontSize: 16)),
    ],
  );
}

