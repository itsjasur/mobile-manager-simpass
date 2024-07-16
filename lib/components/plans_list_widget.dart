import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/pages/form_details.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';

class PlansListWidget extends StatefulWidget {
  final String typeCd;
  final String carrierCd;
  final String mvnoCd;
  final String searchText;
  final bool asPopup;
  const PlansListWidget({super.key, required this.typeCd, required this.carrierCd, required this.mvnoCd, this.searchText = '', this.asPopup = false});

  @override
  State<PlansListWidget> createState() => _PlansListWidgetState();
}

class _PlansListWidgetState extends State<PlansListWidget> {
  final TextEditingController _searchTextCntr = TextEditingController();

  List _plans = [];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  @override
  void dispose() {
    _searchTextCntr.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: CustomTextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _searchTextCntr,
            decoration: const InputDecoration(
              label: Text('요금제명을'),
            ),
            onChanged: (value) => _fetchPlans(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          // height: 60,
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            itemCount: _plans.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return _buildCardWwidget(_plans[index]);
            },
          ),
        ),
        const SizedBox(height: 400),
      ],
    );
  }

  Widget _buildCardWwidget(item) {
    double displayWidth = MediaQuery.of(context).size.width;

    Widget planNameW = Text(
      item['usim_plan_nm'],
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );

    Widget dataRowW = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.signal_cellular_alt,
          size: 18,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            (item['cell_data'] ?? "") + (item['qos'] ?? ""),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    Widget messageRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.email,
          size: 18,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            item['message'] ?? "",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    Widget voiceRow = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.phone,
          size: 18,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            item['voice'] ?? "",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );

    Widget priceRow = Text(
      "${InputFormatter().wonify(item['sales_fee'])} 원/월",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Material(
        color: Theme.of(context).colorScheme.onPrimary,
        child: InkWell(
          onTap: () async {
            if (widget.asPopup) {
              Navigator.pop(context, item);
            } else {
              // await Navigator.pushNamed(context, '/form-details');
              Navigator.push(context, MaterialPageRoute(builder: (context) => FormDetailsPage(searchText: _searchTextCntr.text, planId: item['id'])));
            }
          },
          child: Container(
            constraints: const BoxConstraints(minHeight: 60),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: displayWidth < 600
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(child: planNameW),
                          Flexible(child: priceRow),
                        ],
                      ),
                      const SizedBox(height: 10),
                      dataRowW,
                      const SizedBox(height: 5),
                      voiceRow,
                      const SizedBox(height: 5),
                      messageRow,
                      const SizedBox(height: 5),
                    ],
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      double w = constraints.maxWidth;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: w * 0.25,
                            child: planNameW,
                          ),
                          SizedBox(width: w * 0.01),
                          SizedBox(
                            width: w * 0.2,
                            child: dataRowW,
                          ),
                          SizedBox(width: w * 0.01),
                          SizedBox(
                            width: w * 0.2,
                            child: voiceRow,
                          ),
                          SizedBox(width: w * 0.01),
                          SizedBox(
                            width: w * 0.15,
                            child: messageRow,
                          ),
                          SizedBox(width: w * 0.01),
                          SizedBox(
                            width: w * 0.15,
                            child: priceRow,
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchPlans() async {
    _plans.clear();

    try {
      final response = await Request().requestWithRefreshToken(url: 'agent/planlist', method: 'POST', body: {
        "carrier_type": widget.typeCd, // 선불:PR ,후불:PO
        "carrier_cd": widget.carrierCd, // SKT : SK ,KT : KT,LG U+ : LG
        "mvno_cd": widget.mvnoCd,
        "usim_plan_nm": _searchTextCntr.text,
      });
      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      // print(decodedRes);

      if (decodedRes['statusCode'] != 200) throw decodedRes['message'] ?? 'Fetch data error';

      if (decodedRes['statusCode'] == 200) {
        _plans = decodedRes['data']['info'];
        setState(() {});
      }
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
