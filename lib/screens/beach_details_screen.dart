import 'package:flutter/material.dart';

class BeachDetailsScreen extends StatelessWidget {
  final String beachName;
  final String safetyStatus;
  final String tideStatus;
  final String timings;

  BeachDetailsScreen({
    required this.beachName,
    required this.safetyStatus,
    required this.tideStatus,
    required this.timings,
  });
  //'Juhu Beach', 'Marine Drive', 'Versova Beach','Anjuna Beach','Porbandar Beach','Mandvi Beach','Rushikonda Beach','Bheemunipatnam Beach','Dona Paula Beach','Somnath Beach','Mypad Beach'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beachName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Timings')),
              DataColumn(label: Text('Safety')),
              DataColumn(label: Text('Tides')),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text('9:00 AM - 11:00 AM')),
                DataCell(Text('Unsafe', style: TextStyle(color: Colors.red))),
                DataCell(Text('High Tide', style: TextStyle(color: Colors.red))),
              ]),
              DataRow(cells: [
                DataCell(Text('11:00 AM - 1:00 PM')),
                DataCell(Text('Safe', style: TextStyle(color: Colors.green))),
                DataCell(Text('Moderate Tide', style: TextStyle(color: Colors.orange))),
              ]),
              DataRow(cells: [
                DataCell(Text('1:00 PM - 3:00 PM')),
                DataCell(Text('Caution', style: TextStyle(color: Colors.orange))),
                DataCell(Text('Low Tide', style: TextStyle(color: Colors.green))),
              ]),
              DataRow(cells: [
                DataCell(Text('3:00 PM - 5:00 PM')),
                DataCell(Text('Safe', style: TextStyle(color: Colors.green))),
                DataCell(Text('Moderate Tide', style: TextStyle(color: Colors.orange))),
              ]),
              DataRow(cells: [
                DataCell(Text('5:00 PM - 7:00 PM')),
                DataCell(Text('Caution', style: TextStyle(color: Colors.orange))),
                DataCell(Text('Low Tide', style: TextStyle(color: Colors.green))),
              ]),
              DataRow(cells: [
                DataCell(Text('7:00 PM - 9:00 PM')),
                DataCell(Text('Unsafe', style: TextStyle(color: Colors.red))),
                DataCell(Text('High Tide', style: TextStyle(color: Colors.red))),
              ]),
              // Add more rows as needed
            ],
          ),
        ),
      ),
    );
  }
}
