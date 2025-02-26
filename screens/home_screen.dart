import 'package:flutter/material.dart';
import 'party_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Party Management")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PartyFormScreen()),
            );
          },
          child: const Text("Plan a Party"),
        ),
      ),
    );
  }
}
