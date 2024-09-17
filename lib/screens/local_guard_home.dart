import 'package:flutter/material.dart';

class LocalGuardHomeScreen extends StatelessWidget {
  final List<String> beaches = ['Juhu Beach', 'Marine Drive', 'Versova Beach','Anjuna Beach','Porbandar Beach','Mandvi Beach','Rushikonda Beach'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Beaches List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Beach',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: beaches.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(beaches[index]),
                  onTap: () {
                    // Handle beach selection for Local Guard
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
