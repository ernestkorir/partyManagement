import 'package:flutter/material.dart';
import '../models/party.dart';
import '../services/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PartyDetailsScreen extends StatefulWidget {
  @override
  _PartyDetailsScreenState createState() => _PartyDetailsScreenState();
}

class _PartyDetailsScreenState extends State<PartyDetailsScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final TextEditingController _partyNameController = TextEditingController();
  final TextEditingController _venueController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  final TextEditingController _dressCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _firebaseService.getPartyDetails().listen((party) {
      if (party != null) {
        setState(() {
          _partyNameController.text = party.partyName;
          _venueController.text = party.venue;
          _selectedTime = party.time;
          _dressCodeController.text = party.dressCode;
        });
      }
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedTime),
      );
      if (timePicked != null) {
        setState(() {
          _selectedTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            timePicked.hour,
            timePicked.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Party Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _partyNameController,
              decoration: InputDecoration(labelText: 'Party Name'),
            ),
            TextField(
              controller: _venueController,
              decoration: InputDecoration(labelText: 'Venue'),
            ),
            ListTile(
              title: Text(
                  'Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedTime)}'),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectTime(context),
            ),
            TextField(
              controller: _dressCodeController,
              decoration: InputDecoration(labelText: 'Dress Code'),
            ),
            ElevatedButton(
              onPressed: () {
                print("Button pressed!");
                Party party = Party(
                  id: '',
                  partyName: _partyNameController.text,
                  venue: _venueController.text,
                  time: _selectedTime,
                  dressCode: _dressCodeController.text,
                );
                print("Party Object: ${party.toJson()}"); // Added this line
                _firebaseService.savePartyDetails(party);
              },
              child: Text('Save Party Details'),
            ),
          ],
        ),
      ),
    );
  }
}