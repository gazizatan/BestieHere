import 'package:flutter/material.dart';
import '../widgets/bestie_bottom_nav_bar.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        backgroundColor: Color(0xFFFBC2EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'No messages yet. Stay safe! 💌',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFB23A48),
            fontFamily: 'ComicNeue',
          ),
        ),
      ),
      bottomNavigationBar: const BestieBottomNavBar(currentIndex: 2),
    );
  }
}