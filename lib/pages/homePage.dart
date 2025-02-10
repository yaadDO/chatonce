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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Text(
          'Molo',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontSize: 40,
            fontFamily: 'outofafrica',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.grey,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, color: Theme.of(context).colorScheme.tertiary),
            onPressed: () => _addContact(context),
          ),
        ],
      ),
      drawer: myDrawer(),
      body: _buildUserList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FriendRequestsPage()),
          );
        },
        child: const Icon(Icons.maps_ugc_rounded),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        tooltip: 'Friend Requests',
      ),
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
          return const Text(
            'No contacts found. Add some contacts to start chatting!',
          );
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
    } else {
      return Container();
    }
  }

  void _addContact(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Enter email'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final email = emailController.text.trim();

                if (email.isNotEmpty) {
                  try {
                    await _chatService.sendFriendRequest(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Friend request sent')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }

                Navigator.pop(context);
              },
              child: const Text('Send Request'),
            ),
          ],
        );
      },
    );
  }
}

class FriendRequestsPage extends StatelessWidget {
  final ChatService _chatService = ChatService();

  FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: StreamBuilder(
        stream: _chatService.getFriendRequests(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error loading requests');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Text('No friend requests');
          }

          List<Map<String, dynamic>> requests = snapshot.data!;

          return StatefulBuilder(
            builder: (context, setState) {
              return ListView(
                children: requests.map<Widget>((request) {
                  return ListTile(
                    title: Text(request['fromUserEmail']),
                    trailing: IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        try {
                          await _chatService.acceptFriendRequest(
                            request['requestID'],
                            request['fromUserID'],
                            request['fromUserEmail'],
                          );

                          // Update the state to remove the accepted request
                          setState(() {
                            requests.remove(request);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Friend request accepted')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${e.toString()}')),
                          );
                        }
                      },
                    ),
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
