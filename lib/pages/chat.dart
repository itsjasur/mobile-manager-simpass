import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/models/authentication.dart';
import 'package:mobile_manager_simpass/models/websocket.dart';
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
    Provider.of<AuthenticationModel>(context, listen: false).setProviderValues();
    Provider.of<WebSocketModel>(context, listen: false).connect();
    print('chats page initiazlied');
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

  Widget _chatAndImageBubble(String? text, List<dynamic>? imagePaths, bool mychat) {
    // developer.log(imagePaths.toString());
    if ((text != null && text.isNotEmpty) || (imagePaths != null && imagePaths.isNotEmpty)) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: IntrinsicWidth(
          child: Column(
            children: [
              if (text != null && text.isNotEmpty)
                Container(
                  alignment: mychat ? Alignment.centerRight : null,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  constraints: const BoxConstraints(minHeight: 45, minWidth: 100),
                  decoration: BoxDecoration(
                    color: mychat ? Theme.of(context).colorScheme.primary : Colors.black54,
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
                  (imagePath) => Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        imagePath,
                        width: 250,
                        // height: 100,
                      ),
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
          title: Text(socketProvider.selectedRoom?['agent_name'] ?? "No agent_name"),
          actions: [
            Icon(
              socketProvider.isConnected ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
              color: Colors.green,
            ),
            const SizedBox(width: 20),
          ],
        ),
        body: Consumer<AuthenticationModel>(
          builder: (context, authprovider, child) => authprovider.userName == null
              ? const Center(child: Text('Cannot find current user'))
              : GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: CustomScrollView(
                            reverse: true,
                            controller: _scrollController,
                            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  childCount: socketProvider.chats.length,
                                  (BuildContext context, int index) {
                                    Map chat = socketProvider.chats[index];

                                    if (authprovider.userName == chat['sender']) {
                                      return Align(
                                        alignment: Alignment.centerRight,
                                        child: _chatAndImageBubble(chat['text'], chat['attachment_paths'], true),
                                      );
                                    }
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: _chatAndImageBubble(chat['text'], chat['attachment_paths'], false),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
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
                                          // focusNode: FocusNode(),
                                          // onSubmitted: (value) => _sendMessage(),
                                          // textInputAction: TextInputAction.send,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          autocorrect: false,
                                          enableSuggestions: false,
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
      ),
    );
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isEmpty && _attachedFiles.isEmpty) return;

    String? messageText = _controller.text;
    _controller.clear();
    setState(() {});

    print('send message called');
    List<String> attachmentPaths = await _uploadImages();

    if (mounted) {
      Provider.of<WebSocketModel>(context, listen: false).sendMessage(messageText, attachmentPaths);
    }

    _attachedFiles = [];
    _scrollToBottom();
    setState(() {});
  }

  Future<List<String>> _uploadImages() async {
    final uri = Uri.parse('${IMAGEUPLOADURL}upload');
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
}

// onKeyEvent: (value) {
//   int selectionStart = _controller.selection.start;
//   int selectionEnd = _controller.selection.end;
//   String cursorLeftSide = _controller.text.substring(0, selectionStart);
//   String cursorRightSide = _controller.text.substring(selectionEnd);

//   if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.enter)) {
//     if (HardwareKeyboard.instance.isShiftPressed) {
//       cursorLeftSide += '\n';
//       _controller.text = cursorLeftSide + cursorRightSide;
//       _controller.selection = TextSelection.fromPosition(TextPosition(offset: selectionStart + 1));
//     } else {
//       if (_controller.text.isNotEmpty || _attachedFiles.isNotEmpty) {
//         _sendMessage();
//         // _controller.clear();
//         // setState(() {});
//       }
//     }
//   }
// },

// onKeyEvent: (KeyEvent value) {
//   if (value is KeyDownEvent && value.logicalKey == LogicalKeyboardKey.enter) {
//     if (HardwareKeyboard.instance.isShiftPressed) {
//       final text = _controller.text;
//       final selection = _controller.selection;
//       final newText = text.replaceRange(selection.start, selection.end, '\n');
//       _controller.value = TextEditingValue(
//         text: newText,
//         selection: TextSelection.collapsed(offset: selection.start + 1),
//       );
//     } else {
//       if (_controller.text.isNotEmpty || _attachedFiles.isNotEmpty) {
//         _sendMessage();
//       }
//     }
//   }
// },
