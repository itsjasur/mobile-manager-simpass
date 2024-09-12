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

  const ImagePickerContainer({
    super.key,
    this.getImages,
    this.isRow = false,
    this.radius = 4,
    this.buttonText = '이미지 선택',
    this.multipleUploable = true,
    this.getImage,
  });

  @override
  State<ImagePickerContainer> createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onPrimary,
      child: InkWell(
        borderRadius: BorderRadius.circular(widget.radius),
        onTap: _showImageSourceDialog,
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
                Icons.add_a_photo,
                color: Theme.of(context).colorScheme.primary,
                size: 22,
              ),
              const SizedBox(height: 3, width: 5),
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

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("이미지 선택"),
          content: const Text("이미지를 어디서 가져올까요?"),
          actions: [
            TextButton(
              child: const Text("갤러리"),
              onPressed: () {
                Navigator.of(context).pop();
                widget.multipleUploable ? pickImagesFromGallery() : pickImageFromGallery();
              },
            ),
            TextButton(
              child: const Text("카메라"),
              onPressed: () {
                Navigator.of(context).pop();
                pickImageFromCamera();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> pickImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> xFiles = await picker.pickMultiImage();
      if (xFiles.isNotEmpty) {
        List<File> files = xFiles.map((xFile) => File(xFile.path)).toList();
        widget.getImages?.call(files);
      } else {
        showCustomSnackBar('이미지가 선택되지 않았습니다');
      }
    } catch (e) {
      showCustomSnackBar('이미지 선택 중 오류 발생: $e');
    }
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
      if (xFile != null) {
        widget.getImage?.call(File(xFile.path), xFile.name);
      } else {
        showCustomSnackBar('이미지가 선택되지 않았습니다');
      }
    } catch (e) {
      showCustomSnackBar('이미지 선택 중 오류 발생: $e');
    }
  }

  Future<void> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? xFile = await picker.pickImage(source: ImageSource.camera);
      if (xFile != null) {
        if (widget.multipleUploable) {
          widget.getImages?.call([File(xFile.path)]);
        } else {
          widget.getImage?.call(File(xFile.path), xFile.name);
        }
      } else {
        showCustomSnackBar('사진이 촬영되지 않았습니다');
      }
    } catch (e) {
      showCustomSnackBar('카메라 사용 중 오류 발생: $e');
    }
  }
}
