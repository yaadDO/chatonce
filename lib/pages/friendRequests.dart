import 'package:flutter/material.dart';

import '../chat/chatServices.dart';

class FriendRequestsPage extends StatelessWidget {
  final ChatService _chatService = ChatService();

  FriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
