import 'package:flutter/material.dart';

class MedicineSearchBar extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;

  MedicineSearchBar({required this.hintText, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: onChanged,
    );
  }
}
