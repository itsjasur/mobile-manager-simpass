import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showSignaturePadDialogue(BuildContext context) async {
  bool result = false;
  print('warning dialoged called');
  var res = await showDialog(
    barrierDismissible: false,
    useSafeArea: true,
    useRootNavigator: true,
    context: context,
    builder: (context) => Align(
      child: Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          // padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  // color: Colors.amber,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Title',
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {},
                        icon: Icon(
                          Icons.close_outlined,
                          color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                          size: 24,
                        ),
                      ),
                    ],
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
      ),
    ),
  );

  print(res);
  return result;
}
