import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class  MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarListScreen(),
    );
  }
}

class CarListScreen extends StatefulWidget {
  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  List cars = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    final url = Uri.parse("http://10.0.2.2:5000/auto");  // Cambiato per la tabella "auto"
    try {
      final response = await http.get(url);
      print("Risposta API: ${response.body}"); // Debug

      if (response.statusCode == 200) {
        setState(() {
          cars = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Errore nel caricamento");
      }
    } catch (e) {
      print("Errore: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchCarById(String id) async {
    final url = Uri.parse("http://10.0.2.2:5000/auto/$id");  // Cambiato per la tabella "auto"
    try {
      final response = await http.get(url);
      print("Risposta API (ID $id): ${response.body}"); // Debug

      if (response.statusCode == 200) {
        final car = json.decode(response.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Dettagli Auto"),
            content: Text("Modello: ${car['make'] ?? car['marca']} ${car['model'] ?? car['modello']}\nAnno: ${car['year'] ?? '-'}\nMotore: ${car['motore'] != null ? car['motore']['cavalli'].toString() + ' HP' : '-'}"),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))],
          ),
        );
      } else {
        throw Exception("Errore nel caricamento");
      }
    } catch (e) {
      print("Errore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lista Auto")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text("${car['make'] ?? car['marca']} ${car['model'] ?? car['modello']}",
                        style:const  TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Anno: ${car['year'] ?? '-'}"),
                        Text("Carrozzeria: ${car['carrozzeria'] ?? '-'}"),
                        Text("Motore: ${car['motore'] != null ? car['motore']['cavalli'].toString() + ' HP' : '-'}"),
                        Text("Difetti comuni: ${car['common_issues'] ?? car['difetti_comuni'] ?? []}"),
                      ],
                    ),
                    leading: const Icon(Icons.directions_car),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () => fetchCarById(car['id']), // Chiamata API per ID
                    ),
                  ),
                );
              },
            ),
    );
  }
}
