import 'package:chatonce/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getContactsStream() {
    final String currentUserID = _auth.currentUser!.uid;

    return _firestore
        .collection('Users')
        .doc(currentUserID)
        .collection('contacts')
        .where('status', isEqualTo: 'Accepted')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }


  Future<void> sendMessage(String recieverID, message) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        recieverID: recieverID,
        message: message,
        timestamp:timestamp,
    );

    List<String> ids = [currentUserID, recieverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    await _firestore.
    collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');
    
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> addContact(String contactID, String contactEmail) async {
    final String currentUserID = _auth.currentUser!.uid;

    await _firestore
        .collection('Users')
        .doc(currentUserID)
        .collection('contacts')
        .doc(contactID)
        .set({
      'uid': contactID,
      'email': contactEmail,
    });

    // Optionally, add the current user to the contact's contacts list
    await _firestore
        .collection('Users')
        .doc(contactID)
        .collection('contacts')
        .doc(currentUserID)
        .set({
      'uid': currentUserID,
      'email': _auth.currentUser!.email,
    });
  }
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final snapshot = await _firestore
        .collection('Users')
        .where('email', isEqualTo: email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }

    return null;
  }
  Future<void> sendFriendRequest(String recipientEmail) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Fetch the recipient's user ID
    final recipientDoc = await _firestore
        .collection('Users')
        .where('email', isEqualTo: recipientEmail)
        .get();

    if (recipientDoc.docs.isEmpty) {
      throw Exception('User not found');
    }

    final recipientID = recipientDoc.docs.first.id;

    // Add the friend request to the recipient's friendRequests subcollection
    await _firestore
        .collection('Users')
        .doc(recipientID)
        .collection('friendRequests')
        .add({
      'fromUserID': user.uid,
      'fromUserEmail': user.email,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Map<String, dynamic>>> getFriendRequests() {
    final String currentUserID = _auth.currentUser!.uid;

    return _firestore
        .collection('Users')
        .doc(currentUserID)
        .collection('friendRequests')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'requestID': doc.id, // Include the ID for updates
        };
      }).toList();
    });
  }
  Future<void> acceptFriendRequest(String requestID, String fromUserID, String fromUserEmail) async {
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;

    // Update friend request to "Accepted"
    await _firestore
        .collection('Users')
        .doc(currentUserID)
        .collection('friendRequests')
        .doc(requestID)
        .update({'status': 'Accepted'});

    // Add to current user's contacts
    await _firestore
        .collection('Users')
        .doc(currentUserID)
        .collection('contacts')
        .doc(fromUserID)
        .set({
      'uid': fromUserID,
      'email': fromUserEmail,
      'status': 'Accepted',
    });

    // Add to sender's contacts
    await _firestore
        .collection('Users')
        .doc(fromUserID)
        .collection('contacts')
        .doc(currentUserID)
        .set({
      'uid': currentUserID,
      'email': currentUserEmail,
      'status': 'Accepted',
    });
  }


}