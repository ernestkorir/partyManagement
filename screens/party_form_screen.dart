import 'package:flutter/material.dart';

class PartyFormScreen extends StatefulWidget {
  const PartyFormScreen({super.key});

  @override
  _PartyFormScreenState createState() => _PartyFormScreenState();
}

class _PartyFormScreenState extends State<PartyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String _partyName = "";
  String _venue = "";
  String _dressCode = "";
  String _foodPreference = "Vegetarian";
  int _guestCount = 1;
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Party Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Party Name"),
                validator: (value) =>
                    value!.isEmpty ? "Enter party name" : null,
                onSaved: (value) => _partyName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Venue"),
                validator: (value) => value!.isEmpty ? "Enter venue" : null,
                onSaved: (value) => _venue = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Dress Code"),
                onSaved: (value) => _dressCode = value!,
              ),
              DropdownButtonFormField<String>(
                value: _foodPreference,
                items: ["Vegetarian", "Non-Vegetarian"]
                    .map((food) =>
                        DropdownMenuItem(value: food, child: Text(food)))
                    .toList(),
                onChanged: (value) => setState(() => _foodPreference = value!),
                decoration: const InputDecoration(labelText: "Food Preference"),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Number of Guests"),
                onSaved: (value) => _guestCount = int.parse(value!),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _showConfirmationDialog();
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Party Planned Successfully!"),
          content: Text("Your party $_partyName is set at $_venue."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
