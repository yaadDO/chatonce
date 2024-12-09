import 'package:chatonce/chat/chatServices.dart';
import 'package:chatonce/templates/userTile.dart';
import 'package:flutter/material.dart';

import '../auth/authService.dart';
import '../drawer.dart';
import 'chatPage.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () => _addContact(context),
          ),
        ],
      ),
      drawer: const myDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getContactsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text('No contacts found. Add some contacts to start chatting!');
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }


  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                recieverEmail: userData["email"],
                recieverID: userData['uid'],
              ),
            ),
          );
        },
      );
    }else{
      return Container();
    }
  }
  void _addContact(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Contact'),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Enter email'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();

                if (email.isNotEmpty) {
                  // Fetch the user by email
                  final userDoc = await _chatService.getUserByEmail(email);
                  if (userDoc != null) {
                    await _chatService.addContact(userDoc['uid'], email);
                  }
                }

                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

}

