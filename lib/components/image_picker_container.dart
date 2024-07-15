import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerContainer extends StatefulWidget {
  final Function(List<File>)? getImages;

  const ImagePickerContainer({super.key, required this.getImages});

  @override
  State<ImagePickerContainer> createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  @override
  build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onPrimary,
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 100,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: pickImagesFromGallery,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 3),
                const Text(
                  '이미지 업로드',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> pickImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> xFiles = await picker.pickMultiImage();
      if (xFiles.isNotEmpty) {
        print('Selected ${xFiles.length} images');

        // converts XFile list to File list
        List<File> files = xFiles.map((xFile) => File(xFile.path)).toList();

        widget.getImages?.call(files);
        // if (widget.getImages != null) widget.getImages!(files);
      } else {
        print('No images selected');
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  // Future<void> uploadFiles(List<File> files) async {
  //   var uri = Uri.parse('YOUR_UPLOAD_URL');
  //   var request = http.MultipartRequest('POST', uri);

  //   for (var file in files) {
  //     var stream = http.ByteStream(file.openRead());
  //     var length = await file.length();
  //     var multipartFile = http.MultipartFile('files', stream, length, filename: file.path.split('/').last);
  //     request.files.add(multipartFile);
  //   }

  //   try {
  //     var response = await request.send();
  //     if (response.statusCode == 200) {
  //       print('Files uploaded successfully');
  //     } else {
  //       print('Failed to upload files');
  //     }
  //   } catch (e) {
  //     print('Error uploading files: $e');
  //   }
  // }
}
