import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
import 'package:mobile_manager_simpass/pages/chat.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as developer;

class ChatRooms extends StatefulWidget {
  const ChatRooms({super.key});

  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  @override
  void initState() {
    super.initState();
    Provider.of<WebSocketModel>(context, listen: false).connect();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<WebSocketModel>(
        builder: (context, websocketProvider, child) => websocketProvider.chatRooms.isEmpty
            ? const SizedBox()
            : ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemCount: websocketProvider.chatRooms.length,
                padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                itemBuilder: (context, index) {
                  Map roomDetails = websocketProvider.chatRooms[index];
                  Map? agentDetails = _agentList.where((i) => i['agent_cd'] == roomDetails['agent_code']).firstOrNull;

                  String? roomId = roomDetails['room_id'];
                  String? agentName = agentDetails?['agent_nm'];

                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (roomId != null && agentName != null) {
                          developer.log(websocketProvider.myUsername.toString());
                          websocketProvider.selectRoom(roomId, agentName);

                          await showDialog(
                            context: context,
                            useSafeArea: false,
                            builder: (BuildContext context) => const ChatPage(),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        child: Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(50)),
                            ),
                            Expanded(
                              child: Text(
                                agentDetails?['agent_nm'] ?? "",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (roomDetails['partner_unread_count'] > 0)
                              Container(
                                height: 20,
                                margin: const EdgeInsets.only(left: 5),
                                constraints: const BoxConstraints(minWidth: 20),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Text(
                                  roomDetails['partner_unread_count'].toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/userInfo', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 200) throw decodedRes['message'] ?? "Fetch agentlist error";

      // developer.log(decodedRes.toString());
      String? username = decodedRes['data']?['info']?['username'];
      if (username != null && mounted) {
        Provider.of<WebSocketModel>(context, listen: false).setUsername(username);
        await _fetchAgentList();
      }
      // developer.log(_myUsername.toString());
      // setState(() {});
    } catch (e) {
      // print('profile error: $e');
      showCustomSnackBar(e.toString());
    }
  }

  List _agentList = [];

  Future<void> _fetchAgentList() async {
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/agentlist', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 200) throw decodedRes['message'] ?? "Fetch agentlist error";

      _agentList = decodedRes['data']?['agentlist'] ?? [];

      // developer.log(res.toString());
      // developer.log('agent list $_agentList');

      if (_agentList.isNotEmpty && mounted) {
        Provider.of<WebSocketModel>(context, listen: false).getChatRooms();
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
