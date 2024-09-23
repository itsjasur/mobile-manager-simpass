// ignore: non_constant_identifier_names
import 'package:flutter/services.dart';

// FilteringTextInputFormatter koreanAndEnlishRegexp = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣ᆞᆢ \- ㆍᆞ]'))
FilteringTextInputFormatter koreanAndEnlishRegexp = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z가-힣ㆍᆢㄱ-ㅎㅏ-ㅣ \-]'));

final sideMenuNames = [
  '홈',
  '나의 정보',
  '가입/번호이동 신청서',
  '신청서 (접수/개통) 현황',
  '신청서양식 다운로드',
  '설정',
];
