import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../screens/chat/chat_list_screen.dart';

class ChatDetailScreen extends StatelessWidget {
  final ChatItem chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chat.name),
        backgroundColor: AppTheme.primaryBlue,
      ),
      body: Center(
        child: Text('Chat con ${chat.name} en desarrollo.'),
      ),
    );
  }
}
