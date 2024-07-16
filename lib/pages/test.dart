// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class TestPage extends StatefulWidget {
//   const TestPage({super.key});

//   @override
//   State<TestPage> createState() => _TestPageState();
// }

// class _TestPageState extends State<TestPage> {
//   @override
//   build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: 200,
//         width: 200,
//         decoration: BoxDecoration(
//           color: Theme.of(context).colorScheme.onPrimary,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(
//             color: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 onPressed: pickImagesFromGallery,
//                 icon: Icon(
//                   Icons.add,
//                   color: Theme.of(context).colorScheme.primary,
//                 ),
//                 color: Colors.amber,
//               ),
//               const Text(
//                 '이미지 업로드',
//                 style: TextStyle(),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> pickImagesFromGallery() async {
//     final ImagePicker picker = ImagePicker();
//     try {
//       final List<XFile> images = await picker.pickMultiImage();
//       if (images.isNotEmpty) {
//         // print('Selected ${images.length} images');
//         // Process your images here
//         for (var image in images) {
//           File file = File(image.path);
//         }
//       } else {
//         print('No images selected');
//       }
//     } catch (e) {
//       print('Error picking images: $e');
//     }
//   }

//   Future<void> uploadFiles(List<File> files) async {
//     var uri = Uri.parse('YOUR_UPLOAD_URL');
//     var request = http.MultipartRequest('POST', uri);

//     for (var file in files) {
//       var stream = http.ByteStream(file.openRead());
//       var length = await file.length();
//       var multipartFile = http.MultipartFile('files', stream, length, filename: file.path.split('/').last);
//       request.files.add(multipartFile);
//     }

//     try {
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         print('Files uploaded successfully');
//       } else {
//         print('Failed to upload files');
//       }
//     } catch (e) {
//       print('Error uploading files: $e');
//     }
//   }
// }
