import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/custom_drop_down_menu.dart';
import 'package:mobile_manager_simpass/components/custom_snackbar.dart';
import 'package:mobile_manager_simpass/components/custom_text_field.dart';
import 'package:mobile_manager_simpass/components/global_loading.dart';
import 'package:mobile_manager_simpass/components/sidemenu.dart';
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:mobile_manager_simpass/pages/base64_image_view.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';
import 'package:mobile_manager_simpass/utils/request.dart';
// import 'dart:developer' as developer;

class ApplicationsPage extends StatefulWidget {
  final String? status;
  const ApplicationsPage({super.key, this.status});

  @override
  State<ApplicationsPage> createState() => _ApplicationsPageState();
}

class _ApplicationsPageState extends State<ApplicationsPage> {
  final List _dataList = [];
  List _statuses = [];

  int _pageNumber = 1;
  final int _perPage = 10;

  final TextEditingController _searchText = TextEditingController();

  String _selectedFilterType = 'status';
  late String _selectedStatus;

  final TextEditingController _fromDateCntr = TextEditingController(text: InputFormatter().formatDate(DateTime.now().subtract(const Duration(days: 30)).toString()));
  final TextEditingController _toDateCntr = TextEditingController(text: InputFormatter().formatDate(DateTime.now().toString()));

  final InputFormatter _formatter = InputFormatter();

  bool _dataLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.status ?? "";
    _fetchData();
  }

  @override
  void dispose() {
    _searchText.dispose();
    _fromDateCntr.dispose();
    _toDateCntr.dispose();

    super.dispose();
  }

  Widget statusW() => CustomDropdownMenu(
        requestFocusOnTap: true,
        enableSearch: true,
        label: const Text('상태'),
        expandedInsets: EdgeInsets.zero,
        initialSelection: _selectedStatus,
        dropdownMenuEntries: [
          const DropdownMenuEntry(value: '', label: '전체'),
          ..._statuses.map((e) => DropdownMenuEntry(value: e['cd'], label: e['value'])),
        ],
        onSelected: (newValue) async {
          _selectedStatus = newValue ?? "";
        },
      );

  Widget _fromdateW() => CustomTextFormField(
        controller: _fromDateCntr,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text('개통일자 (From)'),
          hintText: '2024-09-25',
        ),
        inputFormatters: [_formatter.date],
        onChanged: (newV) {
          _fromDateCntr.text = _formatter.validateAndCorrectDate(newV);
          setState(() {});
        },
      );

  Widget _todateW() => CustomTextFormField(
        controller: _toDateCntr,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          label: Text('개통일자 (To)'),
          hintText: '2024-12-25',
        ),
        onChanged: (newV) {
          _fromDateCntr.text = _formatter.validateAndCorrectDate(newV);
          setState(() {});
        },
      );
  Widget _searchbuttonW(bool needPop) => ElevatedButton(
        onPressed: () {
          _fetchData();
          if (needPop) Navigator.pop(context);
        },
        child: const Text('조희'),
      );

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    bool isTablet = displayWidth > 600;

    return Scaffold(
      drawer: const SideMenu(),
      appBar: AppBar(title: Text(sideMenuNames[3])),
      body: RefreshIndicator(
        onRefresh: () async {
          _pageNumber = 1;
          await _fetchData();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: _dataLoading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        if (isTablet)
                          Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxWidth: 150),
                                child: CustomDropdownMenu(
                                  requestFocusOnTap: true,
                                  enableSearch: true,
                                  label: const Text('검색 선택'),
                                  expandedInsets: EdgeInsets.zero,
                                  initialSelection: _selectedFilterType,
                                  dropdownMenuEntries: const [
                                    DropdownMenuEntry(value: 'status', label: '상태'),
                                    DropdownMenuEntry(value: 'apply_date', label: '접수일자'),
                                    DropdownMenuEntry(value: 'regis_date', label: '개통일자'),
                                  ],
                                  onSelected: (newValue) async {
                                    _selectedFilterType = newValue ?? "status";
                                    setState(() {});
                                  },
                                ),
                              ),
                              if (_selectedFilterType == 'status')
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 150),
                                  child: statusW(),
                                ),
                              if (_selectedFilterType != 'status')
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 150),
                                  child: _fromdateW(),
                                ),
                              if (_selectedFilterType != 'status')
                                Container(
                                  constraints: const BoxConstraints(maxWidth: 150),
                                  child: _todateW(),
                                ),
                              SizedBox(
                                width: 100,
                                child: _searchbuttonW(false),
                              ),
                            ],
                          ),
                        if (!isTablet)
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  minimumSize: const Size(0, 40),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                      builder: (BuildContext context, StateSetter setState) {
                                        return Dialog(
                                          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: SingleChildScrollView(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                                              child: Wrap(
                                                runSpacing: 20,
                                                spacing: 20,
                                                children: [
                                                  CustomDropdownMenu(
                                                    requestFocusOnTap: true,
                                                    enableSearch: true,
                                                    label: const Text('검색 선택'),
                                                    expandedInsets: EdgeInsets.zero,
                                                    initialSelection: _selectedFilterType,
                                                    dropdownMenuEntries: const [
                                                      DropdownMenuEntry(value: 'status', label: '상태'),
                                                      DropdownMenuEntry(value: 'apply_date', label: '접수일자'),
                                                      DropdownMenuEntry(value: 'regis_date', label: '개통일자'),
                                                    ],
                                                    onSelected: (newValue) async {
                                                      setState(() {
                                                        _selectedFilterType = newValue ?? "status";
                                                      });
                                                    },
                                                  ),
                                                  if (_selectedFilterType == 'status') statusW(),
                                                  if (_selectedFilterType != 'status') _fromdateW(),
                                                  if (_selectedFilterType != 'status') _todateW(),
                                                  SizedBox(width: double.infinity, child: _searchbuttonW(true)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.filter_alt_outlined, size: 20),
                                    SizedBox(width: 5),
                                    Text('필터'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 20),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) => const SizedBox(height: 15),
                          itemCount: _dataList.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildCardWwidget(_dataList[index]);
                          },
                        ),
                        const SizedBox(height: 20),
                        if (_dataList.isNotEmpty)
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 40),
                                backgroundColor: Theme.of(context).colorScheme.tertiary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                _pageNumber++;
                                _fetchData();
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('더보기'),
                                  SizedBox(width: 5),
                                  Icon(Icons.expand_more_outlined, size: 20),
                                ],
                              ),
                            ),
                          ),
                        const SizedBox(height: 400),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardWwidget(item) {
    double displayWidth = MediaQuery.of(context).size.width;
    bool isTablet = displayWidth > 600;

    Color statusColor = Colors.grey;
    if (item['usim_act_status'] == 'A') statusColor = const Color.fromARGB(255, 23, 109, 238);
    if (item['usim_act_status'] == 'P') statusColor = const Color.fromARGB(255, 153, 11, 255);
    if (item['usim_act_status'] == 'W') statusColor = const Color.fromARGB(255, 255, 87, 4);
    if (item['usim_act_status'] == 'C') statusColor = const Color.fromARGB(255, 235, 0, 0);

    Widget statusW = Align(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          item['usim_act_status_nm'] ?? "",
          style: const TextStyle(
            height: 1,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );

    Widget mvnoNameW = Text(
      item['mvno_cd_nm'] ?? "",
      style: const TextStyle(fontSize: 15),
      textAlign: TextAlign.center,
    );

    Widget customerNameW = Text(
      item['name'] ?? "",
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      textAlign: isTablet ? TextAlign.center : TextAlign.end,
    );

    Widget phoneNumberW = Text(
      item['phone_number'] ?? "",
      style: const TextStyle(fontSize: 15),
    );

    Widget applyDateW = Text(
      item['apply_date'] ?? "",
      style: const TextStyle(fontSize: 15),
    );

    Widget regisDateW = Text(
      item['act_date'] ?? "",
      style: const TextStyle(fontSize: 15),
    );

    Widget actionW = IconButton(
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(0),
        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      ),
      onPressed: () async {
        showGlobalLoading(true);
        await _fetchBase64Images(item['act_no']);
        await Future.delayed(Duration.zero);
        showGlobalLoading(false);
      },
      icon: Icon(
        Icons.folder_open,
        size: 23,
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    TextStyle leftStyle = const TextStyle(fontSize: 15);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        color: Theme.of(context).colorScheme.onPrimary,
        constraints: const BoxConstraints(minHeight: 60),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: !isTablet
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('상태:', style: leftStyle),
                      statusW,
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('통신사:', style: leftStyle),
                      Flexible(child: mvnoNameW),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('고객명:', style: leftStyle),
                      Flexible(child: customerNameW),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('휴대폰:', style: leftStyle),
                      Flexible(child: phoneNumberW),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('접수일자:', style: leftStyle),
                      Flexible(child: applyDateW),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('개통일자:', style: leftStyle),
                      Flexible(child: regisDateW),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('가입신청서:', style: leftStyle),
                      Flexible(child: actionW),
                    ],
                  ),
                ],
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: statusW,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 6,
                        child: mvnoNameW,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 10,
                        child: customerNameW,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 6,
                        child: phoneNumberW,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 6,
                        child: applyDateW,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 6,
                        child: regisDateW,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: actionW,
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }

  Future<void> _fetchData() async {
    if (_pageNumber == 1) _dataList.clear();

    try {
      final response = await Request().requestWithRefreshToken(
        url: 'agent/actStatus',
        method: 'POST',
        body: {
          // "act_no": _searchText.text,
          "act_no": '',
          "usim_act_status": _selectedStatus,
          "apply_fr_date": _selectedFilterType == 'apply_date' ? _fromDateCntr.text : "", //접수일자 from
          "apply_to_date": _selectedFilterType == 'apply_date' ? _toDateCntr.text : '', //접수일자 to
          "act_fr_date": _selectedFilterType == 'regis_date' ? _fromDateCntr.text : '', //개통완료일자 from
          "act_to_date": _selectedFilterType == 'regis_date' ? _toDateCntr.text : '', //개통완료일자 to
          "page": _pageNumber,
          "rowLimit": _perPage,
        },
      );
      if (response.statusCode != 200) throw 'agent/actStatus fetch error';

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));

      // print(decodedRes);
      if (_dataList.length >= decodedRes['data']?['totalNum']) _dataList.clear();
      _dataList.addAll(decodedRes['data']['act_list']);
      _statuses = decodedRes['data']['usim_act_status_code'];

      // developer.log(decodedRes.toString());
      _dataLoading = false;
      setState(() {});
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }

  Future<void> _fetchBase64Images(String actNo) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      final response = await Request().requestWithRefreshToken(
        url: 'agent/actForms',
        method: 'POST',
        body: {"act_no": actNo},
      );

      Map decodedRes = await jsonDecode(utf8.decode(response.bodyBytes));
      if (decodedRes['result'] == 'SUCCESS' && decodedRes['data']['apply_forms_list'].isNotEmpty) {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Base64ImageViewPage(
                base64Images: List<String>.from(decodedRes['data']['apply_forms_list']),
                goHome: false,
              ),
            ),
          );
        }
        return;
      }
      throw 'No image found';
    } catch (e) {
      showCustomSnackBar(e.toString());
    }
  }
}
