import 'package:flutter/material.dart';
import 'package:remedi_kopo/remedi_kopo.dart';

Future<KopoModel> showAddressSelect(BuildContext context) async {
  KopoModel model = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 600,
            maxHeight: 800,
          ),
          child: RemediKopo(),
        ),
      ),
    ),
  );
  return model;
}
