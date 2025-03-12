import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/guest.dart';
import '../models/party.dart';

class FirebaseService {
  final CollectionReference guestsCollection =
  FirebaseFirestore.instance.collection('guests');
  final CollectionReference partyCollection =
  FirebaseFirestore.instance.collection('party');

  Future<void> addGuest(Guest guest) async {
    await guestsCollection.add(guest.toJson());
    await incrementGuestCount(); // Increment count after adding guest.
  }

  Stream<List<Guest>> getGuests() {
    return guestsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Guest.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> savePartyDetails(Party party) async {
    print("savePartyDetails called!");
    try {
      print("Fetching query snapshot...");
      final querySnapshot = await partyCollection.get();
      print("Query snapshot fetched! Documents: ${querySnapshot.docs.length}");
      if (querySnapshot.docs.isNotEmpty) {
        print("Updating existing party...");
        try {
          await partyCollection.doc(querySnapshot.docs.first.id).update(party.toJson());
          print("Party updated!");
        } catch (e) {
          print("Error on update: $e");
        }
      } else {
        print("Adding new party...");
        await partyCollection.add(party.toJson());
        print("Party added!");
      }
    } catch (e) {
      print("Error saving party: $e");
    }
    print("savePartyDetails completed!");
  }

  Stream<Party?> getPartyDetails() {
    return partyCollection.snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return Party.fromJson(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      } else {
        return null;
      }
    });
  }

  Future<void> incrementGuestCount() async {
    final counterDoc =
    FirebaseFirestore.instance.collection('counters').doc('guestCount');
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterDoc);
      if (snapshot.exists) {
        final newCount = snapshot.data()?['count'] + 1;
        transaction.update(counterDoc, {'count': newCount});
      } else {
        transaction.set(counterDoc, {'count': 1});
      }
    });
  }

  Future<void> decrementGuestCount() async {
    final counterDoc =
    FirebaseFirestore.instance.collection('counters').doc('guestCount');
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(counterDoc);
      if (snapshot.exists) {
        final newCount = snapshot.data()?['count'] - 1;
        transaction.update(counterDoc, {'count': newCount});
      }
    });
  }

  Stream<int> getGuestCountStream() {
    return FirebaseFirestore.instance
        .collection('counters')
        .doc('guestCount')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data()?['count'] ?? 0;
      } else {
        return 0;
      }
    });
  }

  Future<void> removeGuest(String guestId) async {
    await guestsCollection.doc(guestId).delete();
    await decrementGuestCount(); // Decrement count after removing guest.
  }
}