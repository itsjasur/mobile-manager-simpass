import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/plans_list_widget.dart';
import 'package:mobile_manager_simpass/components/title_header.dart';

Future<int> showPlansPopup(BuildContext context, typeCd, carrierCd, mvnoCd, searchText) async {
  final selectedItem = await showDialog(
    context: context,
    // barrierDismissible: false,
    builder: (context) => Container(
      margin: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Material(
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
                  ),
                ),
              ),
              const TitleHeader(title: '요금제선택'),
            ],
          ),
        ),
      ),
    ),
  );

  return selectedItem['id'];
}