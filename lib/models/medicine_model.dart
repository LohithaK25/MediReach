class Medicine {
  final String id;
  final String name;
  final String composition;
  final List<dynamic> brands;
  final String pharmacyId;

  Medicine({required this.id, required this.name, required this.composition, required this.brands, required this.pharmacyId});

  factory Medicine.fromMap(String id, Map<String, dynamic> data) {
    return Medicine(
      id: id,
      name: data['name'],
      composition: data['composition'],
      brands: data['brands'],
      pharmacyId: data['pharmacyId'],
    );
  }
}
