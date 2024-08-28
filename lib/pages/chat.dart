import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();

    Provider.of<WebSocketModel>(context, listen: false).joinRoom('SJ');
    Provider.of<WebSocketModel>(context, listen: false).setCallback(_scrollToBottom);
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   developer.log('scroll to bottom called');
    //   _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 100),
    //     curve: Curves.easeOut,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketModel>(
      builder: (context, socketProvider, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            socketProvider.isConnected ? 'Connected' : 'Disconnected',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SizedBox(
            height: double.infinity,
            child: Stack(
              children: [
                ListView.separated(
                  controller: _scrollController,
                  shrinkWrap: true,
                  reverse: true,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: 100, left: 20, right: 20),
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemCount: socketProvider.chats.length,
                  itemBuilder: (context, index) {
                    Map chat = socketProvider.chats[index];

                    if (_myUsername != null && _myUsername == chat['sender']) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: IntrinsicWidth(
                          child: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            constraints: const BoxConstraints(minHeight: 45, minWidth: 100),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              chat['text'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: IntrinsicWidth(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          constraints: const BoxConstraints(minHeight: 45, minWidth: 100),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            chat['text'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 10),
                    child: SafeArea(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              controller: _controller,
                              decoration: const InputDecoration(constraints: BoxConstraints(maxHeight: 500)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                _sendMessage();
                                _controller.clear();
                              }
                            },
                            child: const Text('Send'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    Provider.of<WebSocketModel>(context, listen: false).sendMessage(_controller.text, []);
  }

  String? _myUsername;

  Future<void> _fetchData() async {
    // print('fetch data called');
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/userInfo', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 200) {
        throw decodedRes['message'] ?? "Fetch agentlist error";
      }
      developer.log(decodedRes.toString());

      _myUsername = decodedRes['data']?['info']?['username'];
      developer.log(_myUsername.toString());
      setState(() {});

      await _fetchAgentList();
    } catch (e) {
      // print('profile error: $e');
      showCustomSnackBar(e.toString());
    }
  }

  List agentList = [];
  Future<void> _fetchAgentList() async {
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/agentlist', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 200) {
        throw decodedRes['message'] ?? "Fetch agentlist error";
      }
      agentList = decodedRes['data']?['agentlist'] ?? [];
      // print('agent code ${agentList}');

      if (agentList.isNotEmpty && mounted) {
        Provider.of<WebSocketModel>(context, listen: false).joinRoom(agentList[0]['agent_cd']);
      }
    } catch (error) {}
  }
}
