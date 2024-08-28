import 'package:flutter/material.dart';

Future<bool> showWarningDailogue(BuildContext context, String? title, List<String> content) async {
  bool result = false;

  // var res =
  await showDialog(
    //  barrierDismissible: false,
    useRootNavigator: true,
    // barrierColor: Colors.white,
    context: context,
    builder: (context) => Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            const SizedBox(height: 30),
            ...content.map(
              (String item) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(
              width: 100,
              child: ElevatedButton(
                child: const Text('닫기'),
                onPressed: () {
                  result = true;
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );

  return result;
}
