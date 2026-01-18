class Pharmacy {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final String address;

  Pharmacy({required this.id, required this.name, required this.lat, required this.lng, required this.address});

  factory Pharmacy.fromMap(String id, Map<String, dynamic> data) {
    return Pharmacy(
      id: id,
      name: data['name'],
      lat: data['location']['lat'],
      lng: data['location']['lng'],
      address: data['address'],
    );
  }
}
