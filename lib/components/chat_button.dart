import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/pages/chat.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: SafeArea(
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                useSafeArea: false,
                builder: (BuildContext context) => const ChatPage(),
              );
            },
            child: const Row(
              children: [
                Icon(Icons.comment),
                SizedBox(width: 10),
                Text('개통 문의'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
