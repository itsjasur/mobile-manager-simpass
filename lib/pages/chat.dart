import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

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
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      developer.log('scroll to bottom called');
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _chatAndImageBubble(String? text, List<dynamic>? imagePaths) {
    // developer.log(imagePaths.toString());
    if ((text != null && text.isNotEmpty) || (imagePaths != null && imagePaths.isNotEmpty)) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: IntrinsicWidth(
          child: Column(
            children: [
              if (text != null && text.isNotEmpty)
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  constraints: const BoxConstraints(minHeight: 45, minWidth: 100),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              if (imagePaths != null && imagePaths.isNotEmpty)
                ...imagePaths.map(
                  (imagePath) => ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      imagePath,
                      width: 250,
                      // height: 100,
                    ),
                  ),
                )
            ],
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketModel>(
      builder: (context, socketProvider, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: _agentList.isNotEmpty
              ? DropdownMenu(
                  dropdownMenuEntries: _agentList.map((item) => DropdownMenuEntry(label: item['agent_nm'], value: item['agent_cd'].toString())).toList(),
                  initialSelection: _agentList.first?['agent_cd'],
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  inputDecorationTheme: const InputDecorationTheme(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onSelected: (value) {
                    Provider.of<WebSocketModel>(context, listen: false).joinRoom(value.toString());
                    Provider.of<WebSocketModel>(context, listen: false).setCallback(_scrollToBottom);
                  },
                )
              : const SizedBox.shrink(),
          actions: [
            Text(
              socketProvider.isConnected ? 'Connected' : 'Disconnected',
              style: const TextStyle(
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: _myUsername == null || _agentList.isEmpty
            ? const Center(child: Text('Cannot find current user'))
            : GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        reverse: true,
                        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.only(bottom: 100, left: 15, right: 15),
                        itemCount: socketProvider.chats.length,
                        itemBuilder: (context, index) {
                          Map chat = socketProvider.chats[index];

                          if (_myUsername == chat['sender']) {
                            return Align(
                              alignment: Alignment.centerRight,
                              child: _chatAndImageBubble(chat['text'], chat['attachment_paths']),
                            );
                          }
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: _chatAndImageBubble(chat['text'], chat['attachment_paths']),
                          );
                        },
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_attachedFiles.isNotEmpty)
                              Container(
                                height: 100,
                                width: double.infinity,
                                color: Colors.black.withOpacity(0.2),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _attachedFiles.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, imageIndex) => Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 15),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.file(
                                            _attachedFiles[imageIndex],
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            _attachedFiles.removeAt(imageIndex);
                                            setState(() {});
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.yellow,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              padding: const EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 7),
                              child: SafeArea(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      onPressed: pickImagesFromGallery,
                                      child: const Icon(Icons.attach_file),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: TextField(
                                        maxLines: null,
                                        controller: _controller,
                                        decoration: const InputDecoration(constraints: BoxConstraints(maxHeight: 500)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                      ),
                                      onPressed: () {
                                        if (_controller.text.isNotEmpty || _attachedFiles.isNotEmpty) {
                                          _sendMessage();
                                        }
                                      },
                                      child: const Icon(Icons.send),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _sendMessage() async {
    print('send message called');
    List<String> attachmentPaths = await _uploadImages();

    if (mounted) {
      Provider.of<WebSocketModel>(context, listen: false).sendMessage(_controller.text, attachmentPaths);
    }
    _controller.clear();
    _attachedFiles = [];
    setState(() {});
  }

  Future<List<String>> _uploadImages() async {
    final uri = Uri.parse('https://tchat.baroform.com/upload');
    List<String> uploadedFilePaths = [];

    for (var file in _attachedFiles) {
      var request = http.MultipartRequest('POST', uri);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);

      try {
        var response = await request.send();
        if (response.statusCode == 200) {
          final respStr = await response.stream.bytesToString();
          final respJson = json.decode(respStr);
          if (respJson['path'] != null) {
            uploadedFilePaths.add(respJson['path']);
          }
        } else {
          print('Failed to send request. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error uploading file: $e');
        showCustomSnackBar(e.toString());
      }
    }

    return uploadedFilePaths;
  }

  List<File> _attachedFiles = [];
  Future<void> pickImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> xFiles = await picker.pickMultiImage();
      // List<String> originalFilenames = xFiles.map((xFile) => xFile.name).toList();

      if (xFiles.isNotEmpty) {
        // converts XFile list to File list
        List<File> files = xFiles.map((xFile) => File(xFile.path)).toList();

        _attachedFiles.addAll(files);

        setState(() {});
      } else {
        showCustomSnackBar('No images selected');
      }
    } catch (e) {
      showCustomSnackBar('Error picking images: $e');
    }
  }

  List _agentList = [];
  Future<void> _fetchAgentList() async {
    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/agentlist', method: 'GET');
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode != 200) {
        throw decodedRes['message'] ?? "Fetch agentlist error";
      }

      _agentList = decodedRes['data']?['agentlist'] ?? [];
      // developer.log('agent list $_agentList');

      setState(() {});
      if (_myUsername != null && _agentList.isNotEmpty && mounted) {
        Provider.of<WebSocketModel>(context, listen: false).joinRoom(_agentList.first['agent_cd']);
        Provider.of<WebSocketModel>(context, listen: false).setCallback(_scrollToBottom);
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
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
      // developer.log(decodedRes.toString());

      _myUsername = decodedRes['data']?['info']?['username'];

      await _fetchAgentList();

      // developer.log(_myUsername.toString());
      setState(() {});
    } catch (e) {
      // print('profile error: $e');
      showCustomSnackBar(e.toString());
    }
  }
}
