import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  MarkerId? _selectedMarkerId;
  final LatLngBounds _indiaBounds = LatLngBounds(
    southwest: LatLng(6.4622, 68.1100),
    northeast: LatLng(37.1044, 97.2394),
  );

  final LatLng _initialPosition = LatLng(20.5937, 78.9629); // Center of India
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // Define FocusNode
  bool _isSearching = false;
  List<Beach> _filteredBeaches = [];


  // List of beaches
  final List<Beach> beaches = [
    // Andhra Pradesh beaches
    Beach(name: 'Rushikonda Beach',
        position: LatLng(17.7833, 83.3883),
        snippet: 'Andhra Pradesh'),
    Beach(name: 'Bheemunipatnam Beach',
        position: LatLng(17.8924, 83.4520),
        snippet: 'Andhra Pradesh'),
    Beach(name: 'Manginapudi Beach',
        position: LatLng(16.1782, 81.1391),
        snippet: 'Andhra Pradesh'),
    Beach(name: 'Mypad Beach',
        position: LatLng(14.3623, 80.1417),
        snippet: 'Andhra Pradesh'),
    Beach(name: 'Vodarevu Beach',
        position: LatLng(15.8357, 80.3512),
        snippet: 'Andhra Pradesh'),

    // Goa beaches
    Beach(name: 'Colva Beach',
        position: LatLng(15.2793, 73.9220),
        snippet: 'Goa'),
    Beach(name: 'Dona Paula Beach',
        position: LatLng(15.4667, 73.8333),
        snippet: 'Goa'),
    Beach(name: 'Anjuna Beach',
        position: LatLng(15.5819, 73.7432),
        snippet: 'Goa'),
    Beach(name: 'Arambol Beach',
        position: LatLng(15.6869, 73.7046),
        snippet: 'Goa'),

    // Gujarat beaches
    Beach(name: 'Porbandar Beach',
        position: LatLng(21.6421, 69.6293),
        snippet: 'Gujarat'),
    Beach(name: 'Mandvi Beach',
        position: LatLng(22.8327, 69.3460),
        snippet: 'Gujarat'),
    Beach(name: 'Somnath Beach',
        position: LatLng(20.8880, 70.4017),
        snippet: 'Gujarat'),
    Beach(name: 'Chorwad Beach',
        position: LatLng(21.0169, 70.2166),
        snippet: 'Gujarat'),

    // Karnataka beaches
    Beach(name: 'Om Beach',
        position: LatLng(14.5195, 74.3186),
        snippet: 'Karnataka'),
    Beach(name: 'Malpe Beach',
        position: LatLng(13.3522, 74.6869),
        snippet: 'Karnataka'),
    Beach(name: 'Karwar Beach',
        position: LatLng(14.8027, 74.1240),
        snippet: 'Karnataka'),
    Beach(name: 'Kudle Beach',
        position: LatLng(14.5227, 74.3194),
        snippet: 'Karnataka'),

    // Kerala beaches
    Beach(name: 'Varkala Beach',
        position: LatLng(8.7379, 76.7024),
        snippet: 'Kerala'),
    Beach(name: 'Alleppey Beach',
        position: LatLng(9.4906, 76.3264),
        snippet: 'Kerala'),
    Beach(name: 'Kovalam Beach',
        position: LatLng(8.4033, 76.9763),
        snippet: 'Kerala'),
    Beach(name: 'Bekal Beach',
        position: LatLng(12.3666, 75.0419),
        snippet: 'Kerala'),

    // Lakshadweep beaches
    Beach(name: 'Kavaratti Beach',
        position: LatLng(10.5667, 72.6369),
        snippet: 'Lakshadweep'),
    Beach(name: 'Minicoy Beach',
        position: LatLng(8.2955, 73.0464),
        snippet: 'Lakshadweep'),
    Beach(name: 'Kadmat Beach',
        position: LatLng(11.2196, 72.7762),
        snippet: 'Lakshadweep'),
    Beach(name: 'Bangaram Beach',
        position: LatLng(10.9462, 72.2875),
        snippet: 'Lakshadweep'),

    // Maharashtra beaches
    Beach(name: 'Juhu Beach',
        position: LatLng(19.0988, 72.8267),
        snippet: 'Maharashtra'),
    Beach(name: 'Alibag Beach',
        position: LatLng(18.6424, 72.8757),
        snippet: 'Maharashtra'),
    Beach(name: 'Ganpatipule Beach',
        position: LatLng(17.1422, 73.2606),
        snippet: 'Maharashtra'),

    // Odisha beaches
    Beach(name: 'Puri Beach',
        position: LatLng(19.8035, 85.8245),
        snippet: 'Odisha'),
    Beach(name: 'Chandipur Beach',
        position: LatLng(21.4710, 87.0129),
        snippet: 'Odisha'),
    Beach(name: 'Gopalpur Beach',
        position: LatLng(19.2800, 84.8975),
        snippet: 'Odisha'),
    Beach(name: 'Khurda Beach',
        position: LatLng(20.2798, 85.8254),
        snippet: 'Odisha'),

    // Tamil Nadu beaches
    Beach(name: 'Marina Beach',
        position: LatLng(13.0477, 80.2630),
        snippet: 'Tamil Nadu'),
    Beach(name: 'Kovalam Beach',
        position: LatLng(8.4033, 76.9763),
        snippet: 'Tamil Nadu'),
    Beach(name: 'Mahabalipuram Beach',
        position: LatLng(12.6200, 80.1553),
        snippet: 'Tamil Nadu'),
    Beach(name: 'ECR Beach',
        position: LatLng(12.9352, 80.2155),
        snippet: 'Tamil Nadu'),

    // West Bengal beaches
    Beach(name: 'Digha Beach',
        position: LatLng(21.6281, 87.5101),
        snippet: 'West Bengal'),
    Beach(name: 'Shankarpur Beach',
        position: LatLng(21.6350, 87.4488),
        snippet: 'West Bengal'),
    Beach(name: 'Frazerganj Beach',
        position: LatLng(21.6719, 87.5540),
        snippet: 'West Bengal'),
    Beach(name: 'Ganga Sagar Beach',
        position: LatLng(21.6470, 88.8490),
        snippet: 'West Bengal'),

    // Daman beaches
    Beach(name: 'Devka Beach',
        position: LatLng(20.4111, 72.8281),
        snippet: 'Daman'),
    Beach(name: 'Jaypore Beach',
        position: LatLng(20.3823, 72.8461),
        snippet: 'Daman'),

    // Diu beaches
    Beach(name: 'Jallandhar Beach',
        position: LatLng(20.7130, 70.9570),
        snippet: 'Diu'),
    Beach(name: 'Chakratith Beach',
        position: LatLng(20.7136, 70.9638),
        snippet: 'Diu'),
    Beach(name: 'Nagoa Beach',
        position: LatLng(20.7135, 70.9475),
        snippet: 'Diu'),
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

  void _onMarkerTapped(Beach beach) {
    setState(() {
      _selectedMarkerId = MarkerId(beach.name);
      _addMarkers(); // Rebuild markers to apply color changes
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(beach.position, 12.0),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Esri Light Gray Canvas style JSON
    final String esriLightGrayCanvasStyle = '''
  [
    {
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#eeeeee"
        }
      ]
    },
    {
      "elementType": "labels.icon",
      "stylers": [
        {
          "visibility": "off"
        }
      ]
    },
    {
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#666666"
        }
      ]
    },
    {
      "elementType": "labels.text.stroke",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "administrative",
      "elementType": "geometry.stroke",
      "stylers": [
        {
          "color": "#c3c3c3"
        }
      ]
    },
    {
      "featureType": "landscape",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#f5f5f5"
        }
      ]
    },
    {
      "featureType": "poi",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#eeeeee"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#ffffff"
        }
      ]
    },
    {
      "featureType": "road",
      "elementType": "labels.text.fill",
      "stylers": [
        {
          "color": "#666666"
        }
      ]
    },
    {
      "featureType": "water",
      "elementType": "geometry",
      "stylers": [
        {
          "color": "#c6e2ff"
        }
      ]
    }
  ]
  ''';

    _mapController?.setMapStyle(esriLightGrayCanvasStyle);

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
            zoomControlsEnabled: false,
            onTap: (LatLng position) {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                });
              }
              _hideKeyboard(); // Hide the keyboard when tapping on the map
            },
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16, // Move below camera hole
            left: 16, // Align to the left side of the screen
            right: 16, // Align to the right side of the screen
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // Align items to the right
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: MediaQuery.of(context).size.width - 32, // Full screen width minus padding
                  height: _isSearching ? 200 : 48, // Adjust the height based on whether user is searching
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode, // Attach FocusNode
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    _searchBeaches(value);
                                  } else {
                                    setState(() {
                                      _filteredBeaches.clear();
                                    });
                                  }
                                },
                                onSubmitted: (value) {
                                  if (_filteredBeaches.isEmpty) {
                                    _showBeachNotFoundDialog();
                                  }
                                  _hideKeyboard(); // Hide the keyboard after submitting the search
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  hintStyle: TextStyle(color: Colors.white54),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.search, color: Colors.white),
                            onPressed: _onSearchPressed,
                          ),
                        ],
                      ),
                      if (_isSearching && _filteredBeaches.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: _filteredBeaches.length,
                            itemBuilder: (context, index) {
                              final beach = _filteredBeaches[index];
                              return ListTile(
                                title: Text(
                                  beach.name,
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  beach.snippet,
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                                onTap: () {
                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(beach.position, 12.0),
                                  );
                                  _hideKeyboard(); // Hide the keyboard when selecting a beach
                                  setState(() {
                                    _isSearching = false;
                                  });
                                },
                              );
                            },
                          ),
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
