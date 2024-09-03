import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/components/warning.dart';
import 'dart:math' as math;
import 'package:mobile_manager_simpass/globals/constant.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_manager_simpass/pages/secondary_signup.dart';

class SignUpWaitingPopup extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String birthday;
  final String certType;
  final String? employeeCode;
  final String receiptId;

  const SignUpWaitingPopup({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.certType,
    required this.receiptId,
    required this.birthday,
    required this.employeeCode,
  });

  @override
  State<SignUpWaitingPopup> createState() => _SignUpWaitingPopupState();
}

class _SignUpWaitingPopupState extends State<SignUpWaitingPopup> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool wideScreen = screenWidth > 600;

    Widget step1 = Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              widget.certType == 'KAKAO' ? 'assets/logos/kakao.png' : 'assets/logos/pass.png',
              height: 50,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'STEP 01',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 5),
          const Text(
            '앱에서 인증요청 메시지확인',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

    Widget step2 = Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 87, 176, 249),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.task_alt,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'STEP 02',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 5),
          const Text(
            '앱에서 인증서 인증진행(비밀번호 등)',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

    Widget step3 = Container(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 50, 190, 40),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.password,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'STEP 03',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 5),
          const Text(
            '앱 인증완료 후, 하단의 인증완료 클릭',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );

    Widget arrow = SizedBox(
      width: 40,
      height: 40,
      child: Transform.rotate(
        angle: wideScreen ? 0 : 90 * math.pi / 180,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.tertiary,
          size: 25,
        ),
      ),
    );

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '인증을 진행해 주세요',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '입력하신 휴대폰으로인증 요청 메시지를 보냈습니다.',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            const Text(
              '앱에서 인증을 진행해주세요.',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            if (wideScreen)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [step1, arrow, step2, arrow, step3],
              ),
            if (!wideScreen)
              Column(
                children: [step1, arrow, step2, arrow, step3],
              ),
            const SizedBox(height: 30),
            Container(
              width: screenWidth * .8,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: widget.certType == 'KAKAO'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '문제발생시 조치방법',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(text: '1. 카카오인증서 이용에 문제가 있는 경우'),
                              TextSpan(
                                text: '[고객센터 도움말]',
                                style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                              const TextSpan(text: '에서 해결방법을 찾아보세요.'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              const TextSpan(text: '2. 문제가 지속되면'),
                              TextSpan(
                                text: '[고객센터 문의하기]',
                                style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                              const TextSpan(text: '또는'),
                              TextSpan(
                                text: '[상담톡채널]',
                                style: const TextStyle(color: Colors.indigoAccent, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()..onTap = () {},
                              ),
                              const TextSpan(text: '채팅하기를 통해 문의해 주세요.'),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('인증요청(알림)이 휴대폰으로오지 않았다면 아래 순서로 확인해 주세요.'),
                        const SizedBox(height: 10),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: const [
                              TextSpan(
                                text: '1. [PASS 앱 실행>홈화면 또는 인증서 메뉴] ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '에서 인증 요청 내용을 확인할 수 있습니다.'),
                            ],
                          ),
                        ),
                        const Text('2. PASS 앱 설치 확인 및 알림 수신동의 되어있는지 확인해 주세요.'),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: const [
                              TextSpan(text: '3. 문제가 계속된다면'),
                              TextSpan(
                                text: ' [PASS인증서 고객센터:1800-4273] ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '로 연략해 주세요.'),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 30),
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: ElevatedButton(
                onPressed: _checkStatus,
                child: const Text('인증완료'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _checkStatus() async {
    try {
      final response = await http.post(
        Uri.parse('${BASEURL}auth/chkSign'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "name": widget.name,
          "birthday": widget.birthday,
          "cert_phone_number": widget.phoneNumber,
          "id_cert_type": widget.certType,
          "receipt_id": widget.receiptId,
        }),
      );

      Map data = await jsonDecode(utf8.decode(response.bodyBytes));

      // if (true) {
      if (data['result'] == 'SUCCESS') {
        if (mounted) Navigator.pop(context);
        // if (mounted) Navigator.pushNamed(context, '/secondarySignup');
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondarySignup(
                  phoneNumber: widget.phoneNumber,
                  name: widget.name,
                  receiptId: widget.receiptId,
                  certType: widget.certType,
                  birthday: widget.birthday,
                  employeeCode: widget.employeeCode,
                ),
              ));
        }
        return;
      }

      if (data['result'] == 'WAIT') {
        if (mounted) await showWarningDailogue(context, '인증 미완료', [data['message']]);
        return;
      }

      if (data['result'] == 'EXPIRE' || data['result'] == 'ERROR' || data['result'] == 'BAD') {
        if (mounted) await showWarningDailogue(context, '인증 오류', [data['message']]);
        if (mounted) Navigator.pop(context);
        return;
      }

      throw 'Request error';
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
