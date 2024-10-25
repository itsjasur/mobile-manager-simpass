import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/plans_list_widget.dart';
import 'package:mobile_manager_simpass/components/popup_header.dart';

Future<int?> showPlansPopup(BuildContext context, typeCd, carrierCd, mvnoCd, searchText) async {
  final selectedItem = await showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 55),
                  child: PlansListWidget(
                    typeCd: typeCd,
                    carrierCd: carrierCd,
                    mvnoCd: mvnoCd,
                    searchText: searchText,
                    asPopup: true,
                    onlyFavorites: false,
                  ),
                ),
              ),
              const PopupHeader(title: '요금제선택'),
            ],
          ),
        ),
      ),
    ),
  );

  if (selectedItem != null && selectedItem['id'] != null) {
    return selectedItem['id'];
  }
  return null;
}
