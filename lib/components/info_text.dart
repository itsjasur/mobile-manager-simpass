import 'package:flutter/material.dart';
import 'package:mobile_manager_simpass/sensitive.dart';

class InfoText extends StatelessWidget {
  const InfoText({super.key});

  @override
  Widget build(BuildContext context) {
    Widget text(String text) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 14,
        ),
        textAlign: TextAlign.center,
      );
    }

    return APPOWNER == 'sjnetworks'
        ? Column(
            children: [
              text("""상호 : (주)에스제이네트웍스 | 대표 : 백제현"""),
              text("""대표전화 : 1660-3566 | 부산센터 : 1660-3577"""),
              text("""사업자등록번호 : 358-86-02691"""),
              text("""대구광역시 동구 송라로16길 85 C&P빌딩 2층"""),
            ],
          )
        : Column(
            children: [
              text("""상호 : 심패스(Simpass) | 대표 : 김익태"""),
              text("""대표전화 : 02-2108-3121 | FAX : 02-2108-3120"""),
              text("""사업자등록번호 : 343-18-00713"""),
              text("""통신판매신고번호 : 제 2021-서울구로-1451 호"""),
              text("""주소: 서울시 구로구 디지털로33길 28, 우림이비지센터 1차 1210호"""),
            ],
          );
  }
}
