import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
import 'package:mobile_manager_simpass/pages/chat.dart';
import 'package:mobile_manager_simpass/pages/chat_rooms.dart';
import 'package:provider/provider.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: SafeArea(
        child: Consumer<WebSocketModel>(
          builder: (context, websocketProvider, child) => SizedBox(
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
                  builder: (BuildContext context) => const ChatRooms(),
                );
              },
              child: Row(
                children: [
                  // Text(websocketProvider.isConnected ? "Connected" : 'Disconnected'),
                  // const SizedBox(width: 10),
                  const Icon(Icons.comment),
                  const SizedBox(width: 10),
                  const Text('개통 문의'),

                  if (websocketProvider.totalUnreadCount > 0)
                    Container(
                      height: 20,
                      margin: const EdgeInsets.only(left: 10),
                      constraints: const BoxConstraints(minWidth: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(websocketProvider.totalUnreadCount.toString()),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
