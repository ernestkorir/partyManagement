import 'package:flutter/material.dart';

class FoodPreferenceDropdown extends StatelessWidget {
  final String selectedValue;
  final Function(String?) onChanged;

  const FoodPreferenceDropdown({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: ["Vegetarian", "Non-Vegetarian"]
          .map((food) => DropdownMenuItem(value: food, child: Text(food)))
          .toList(),
      onChanged: onChanged,
      decoration: const InputDecoration(labelText: "Food Preference"),
    );
  }
}
