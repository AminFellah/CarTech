import 'package:flutter/material.dart';

class CarCard extends StatelessWidget {
  final String model;
  final String brand;
  final String year;

  const CarCard({
    super.key,
    required this.model,
    required this.brand,
    required this.year,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      color: Colors.black,
      child: ListTile(
        leading: const Icon(Icons.directions_car, size: 40),
        title: Text(model, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$brand - $year"),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
