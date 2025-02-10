import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/themeProvider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser
  });

  @override
  Widget build(BuildContext context) {

    bool isDarkMode =
        Provider.of<ThemeProvider>(context,listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color:isCurrentUser
            ? (isDarkMode ? Colors.deepPurple.shade600: Colors.deepPurple.shade500)
            : (isDarkMode ? Colors.grey.shade700 : Colors.grey.shade400),
        borderRadius: BorderRadius.circular(19),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(message,
        style: TextStyle(
            color: isCurrentUser
            ? Colors.white
            : (isDarkMode ? Colors.white : Colors.black)),
      ),
    );
  }
}
