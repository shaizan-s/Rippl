import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<String> _beaches = [
    'Puri Beach', 'Pati Sonepur Sea Beach', 'Rushikonda Beach', 'Kovalam Beach',
    'Eden Beach', 'Radhanagar Beach', 'Minicoy Thundi Beach', 'Kadmat Beach',
    'Kappad Beach', 'Kasarkod Beach', 'Padubidri Beach', 'Ghoghla Beach',
    'Shivrajpur Beach',
  ];
  List<String> _searchResults = [];
  String? _selectedBeach; // Stores the selected beach from the dropdown

  final LatLng _initialPosition = LatLng(20.5937, 78.9629); // Center of India
  final LatLngBounds _indiaBounds = LatLngBounds(
    southwest: LatLng(6.4626, 68.1758),
    northeast: LatLng(37.0625, 97.3963),
  );

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _addIndiaBorderPolyline();
  }

  void _setMarkers() {
    setState(() {
      _markers.addAll([
        Marker(
          markerId: MarkerId('puri_beach'),
          position: LatLng(19.8030, 85.8252), // Puri Beach
          infoWindow: InfoWindow(title: 'Puri Beach'),
        ),
        Marker(
          markerId: MarkerId('pati_sonepur'),
          position: LatLng(19.1803, 84.7635), // Pati Sonepur Beach
          infoWindow: InfoWindow(title: 'Pati Sonepur Sea Beach'),
        ),
        Marker(
          markerId: MarkerId('rushikonda_beach'),
          position: LatLng(17.7826, 83.3955), // Rushikonda Beach
          infoWindow: InfoWindow(title: 'Rushikonda Beach'),
        ),
        Marker(
          markerId: MarkerId('kovalam_beach'),
          position: LatLng(12.7916, 80.2572), // Kovalam Beach
          infoWindow: InfoWindow(title: 'Kovalam Beach'),
        ),
        Marker(
          markerId: MarkerId('eden_beach'),
          position: LatLng(11.8895, 79.8141), // Eden Beach
          infoWindow: InfoWindow(title: 'Eden Beach'),
        ),
        Marker(
          markerId: MarkerId('radhanagar_beach'),
          position: LatLng(11.9673, 92.9873), // Radhanagar Beach
          infoWindow: InfoWindow(title: 'Radhanagar Beach'),
        ),
        Marker(
          markerId: MarkerId('minicoy_thundi'),
          position: LatLng(8.2876, 73.0487), // Minicoy Thundi Beach
          infoWindow: InfoWindow(title: 'Minicoy Thundi Beach'),
        ),
        Marker(
          markerId: MarkerId('kadmat_beach'),
          position: LatLng(11.2191, 72.7796), // Kadmat Beach
          infoWindow: InfoWindow(title: 'Kadmat Beach'),
        ),
        Marker(
          markerId: MarkerId('kappad_beach'),
          position: LatLng(11.3656, 75.7083), // Kappad Beach
          infoWindow: InfoWindow(title: 'Kappad Beach'),
        ),
        Marker(
          markerId: MarkerId('kasarkod_beach'),
          position: LatLng(14.3667, 74.4403), // Kasarkod Beach
          infoWindow: InfoWindow(title: 'Kasarkod Beach'),
        ),
        Marker(
          markerId: MarkerId('padubidri_beach'),
          position: LatLng(13.1242, 74.7860), // Padubidri Beach
          infoWindow: InfoWindow(title: 'Padubidri Beach'),
        ),
        Marker(
          markerId: MarkerId('ghoghla_beach'),
          position: LatLng(20.7055, 70.9897), // Ghoghla Beach
          infoWindow: InfoWindow(title: 'Ghoghla Beach'),
        ),
        Marker(
          markerId: MarkerId('shivrajpur_beach'),
          position: LatLng(22.3683, 68.9677), // Shivrajpur Beach
          infoWindow: InfoWindow(title: 'Shivrajpur Beach'),
        ),
      ]);
    });
  }

  void _addIndiaBorderPolyline() {
    List<LatLng> indiaBorderCoordinates = [
      LatLng(35.5087, 77.8374), // Example: Northernmost part
      LatLng(31.1857, 74.3587), // Add more coordinates for accuracy
      LatLng(22.5726, 88.3639),
      LatLng(8.0883, 77.5385),
      // Add more points to cover the entire border
    ];

    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('india_border'),
          points: indiaBorderCoordinates,
          color: Colors.black, // Black color for border
          width: 5, // Bold border
        ),
      );
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchResults = _beaches
          .where((beach) => beach.toLowerCase().contains(query.toLowerCase()))
          .toList();
      _searchResults.sort(); // Sort alphabetically based on typed input
    });
  }

  void _onSearchSelected(String beach) {
    LatLng selectedBeachPosition;

    switch (beach) {
      case 'Puri Beach':
        selectedBeachPosition = LatLng(19.8030, 85.8252);
        break;
      case 'Pati Sonepur Sea Beach':
        selectedBeachPosition = LatLng(19.1803, 84.7635);
        break;
      case 'Rushikonda Beach':
        selectedBeachPosition = LatLng(17.7826, 83.3955);
        break;
      case 'Kovalam Beach':
        selectedBeachPosition = LatLng(12.7916, 80.2572);
        break;
      case 'Eden Beach':
        selectedBeachPosition = LatLng(11.8895, 79.8141);
        break;
      case 'Radhanagar Beach':
        selectedBeachPosition = LatLng(11.9673, 92.9873);
        break;
      case 'Minicoy Thundi Beach':
        selectedBeachPosition = LatLng(8.2876, 73.0487);
        break;
      case 'Kadmat Beach':
        selectedBeachPosition = LatLng(11.2191, 72.7796);
        break;
      case 'Kappad Beach':
        selectedBeachPosition = LatLng(11.3656, 75.7083);
        break;
      case 'Kasarkod Beach':
        selectedBeachPosition = LatLng(14.3667, 74.4403);
        break;
      case 'Padubidri Beach':
        selectedBeachPosition = LatLng(13.1242, 74.7860);
        break;
      case 'Ghoghla Beach':
        selectedBeachPosition = LatLng(20.7055, 70.9897);
        break;
      case 'Shivrajpur Beach':
        selectedBeachPosition = LatLng(22.3683, 68.9677);
        break;
      default:
        return;
    }

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(selectedBeachPosition, 12.0));
    setState(() {
      _searchResults.clear();
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController?.animateCamera(CameraUpdate.newLatLngBounds(_indiaBounds, 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Beaches/Coastal Areas',
                border: InputBorder.none,
              ),
              onChanged: _onSearchChanged,
            ),
            if (_searchResults.isNotEmpty)
              DropdownButton<String>(
                value: _selectedBeach,
                hint: Text('Select a Beach'),
                items: _searchResults
                    .map((beach) => DropdownMenuItem<String>(
                  value: beach,
                  child: Text(beach),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBeach = value;
                  });
                  if (value != null) {
                    _onSearchSelected(value);
                  }
                },
              ),
          ],
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 5.0,
        ),
        markers: _markers,
        polylines: _polylines, // Add the India border Polyline
      ),
    );
  }
}
