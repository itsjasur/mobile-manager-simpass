import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';

class ImagePickerContainer extends StatefulWidget {
  final bool isRow;
  final double radius;
  final String buttonText;
  final bool multipleUploable;

  final Function(List<File>)? getImages;
  final Function(File, String)? getImage;

  const ImagePickerContainer({super.key, this.getImages, this.isRow = false, this.radius = 4, this.buttonText = '이미지 업로드', this.multipleUploable = true, this.getImage});

  @override
  State<ImagePickerContainer> createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  @override
  build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onPrimary,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.radius),
        onTap: widget.multipleUploable ? pickImagesFromGallery : pickImageFromGallery,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: Theme.of(context).colorScheme.primary),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            direction: widget.isRow ? Axis.horizontal : Axis.vertical,
            runAlignment: WrapAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
              const SizedBox(height: 3),
              Text(
                widget.buttonText,
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> xFiles = await picker.pickMultiImage();
      // List<String> originalFilenames = xFiles.map((xFile) => xFile.name).toList();

      if (xFiles.isNotEmpty) {
        // converts XFile list to File list
        List<File> files = xFiles.map((xFile) => File(xFile.path)).toList();

        widget.getImages?.call(files);
      } else {
        showCustomSnackBar('No images selected');
      }
    } catch (e) {
      showCustomSnackBar('Error picking images: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? xFile = await picker.pickMedia();

      if (xFile != null) {
        widget.getImage?.call(File(xFile.path), xFile.name);
      } else {
        showCustomSnackBar('No image selected');
      }
    } catch (e) {
      showCustomSnackBar('Error picking images: $e');
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
