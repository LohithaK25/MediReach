import 'package:flutter/material.dart';
import '../models/medicine_model.dart';
import '../models/pharmacy_model.dart';
import '../services/search_service.dart';
import '../services/pharmacy_service.dart';
import '../widgets/medicine_tile.dart';
import '../widgets/pharmacy_card.dart';
import '../widgets/search_bar.dart'; // MedicineSearchBar
import '../utils/constants.dart';
import 'medicine_details_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const HomeScreen({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = "";
  List<Medicine> searchResults = [];
  bool isSearchActive = false;
  bool isLoading = false;

  void onSearchChanged(String text) async {
    setState(() => query = text);
    if (query.isEmpty) {
      setState(() {
        searchResults = [];
        isSearchActive = false;
      });
      return;
    }

    setState(() {
      isSearchActive = true;
      isLoading = true;
    });

    try {
      final results = await SearchService.searchMedicines(query);
      setState(() => searchResults = results);
    } catch (e) {
      print("Search error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(APP_NAME),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: "Profile",
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: MedicineSearchBar(
              hintText: "Search medicines by name, brand, composition",
              onChanged: onSearchChanged,
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isSearchActive && searchResults.isEmpty
                    ? const Center(child: Text("No medicines found.", style: TextStyle(fontSize: 16, color: Colors.grey)))
                    : isSearchActive
                        ? ListView.builder(
                            itemCount: searchResults.length,
                            itemBuilder: (context, index) {
                              final med = searchResults[index];
                              return MedicineTile(
                                medicine: med,
                                latitude: widget.latitude,
                                longitude: widget.longitude,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MedicineDetailsScreen(
                                        medicine: med,
                                        latitude: widget.latitude,
                                        longitude: widget.longitude,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : StreamBuilder<List<Pharmacy>>(
                            stream: PharmacyService.getNearbyPharmacies(widget.latitude, widget.longitude, 10.0),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Center(
                                  child: Text("Nearby pharmacies will appear here.", style: TextStyle(fontSize: 16, color: Colors.grey)),
                                );
                              }
                              final pharmacies = snapshot.data!;
                              return ListView.builder(
                                itemCount: pharmacies.length,
                                itemBuilder: (context, index) => PharmacyCard(pharmacy: pharmacies[index]),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
