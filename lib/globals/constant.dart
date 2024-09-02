// ignore: constant_identifier_names
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';

// ignore: non_constant_identifier_names
// String BASEURL = kReleaseMode ? "https://ta.simpass.co.kr/api/" : "http://192.168.0.251:8091/api/";
// String BASEURL = "http://192.168.0.251:8091/api/";

// ignore: non_constant_identifier_names
String BASEURL = "https://ta.simpass.co.kr/api/";

// ignore: non_constant_identifier_names
String CHATSERVERURL = "wss://tchat.baroform.com/";
// String CHATSERVERURL = "ws://127.0.0.1:8000/";

//android localhost
// String CHATSERVERURL = "ws://10.0.2.2:8000/";

// ignore: non_constant_identifier_names
// String IMAGEUPLOADURL = "https://tchat.baroform.com/";
String IMAGEUPLOADURL = "https://127.0.0.1:8000/";

final sideMenuNames = [
  '홈',
  '나의 정보',
  '가입/번호이동 신청서',
  // '렌탈가입 신청서',
  '신청서 (접수/개통) 현황',
  '신청서양식 다운로드',
  '신청서 (접수/개통) 현황',
];

// Map inputFormsListaa = {
//   //PAYMENT INFO
//   "paid_transfer_cd": {
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '결제구분 선택하세요.',
//     "placeholder": '결제구분 선택하세요',
//     "label": '결제구분',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "account_name": {
//     "value": null, "formatter": null,
//     // "value": 'TEST 예금주명',
//     "type": 'input',
//     "maxwidth": 300,
//     "error": '예금주명 입력하세요.',
//     "placeholder": '홍길동',
//     "label": '예금주명',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//     "capital": true,
//   },

//   "account_birthday": {
//     "value": null,
//     // "value": '91-01-31',
//     "type": 'input',
//     "formatter": InputFormatter().birthdayShort,
//     "maxwidth": 200,
//     "error": '생년월일 입력하세요.',
//     "placeholder": '91-01-31',
//     "label": '예금주 생년월일',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   },
//   "account_birthday_full": {
//     "value": null,
//     "type": 'input',
//     "formatter": InputFormatter().birthday,
//     "maxwidth": 200,
//     "error": '생년월일 입력하세요.',
//     "placeholder": '1991-01-31',
//     "label": '예금주 생년월일',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   },

//   "account_agency": {
//     "value": null, "formatter": null,
//     // "value": 'TEST AGENCY',
//     "type": 'input',
//     "maxwidth": 300,
//     "error": '은행(카드사)명 입력하세요.',
//     "placeholder": '하나은행',
//     "label": '은행(카드사)명',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   },

//   "account_number": {
//     "value": null,
//     "formatter": FilteringTextInputFormatter.digitsOnly,

//     // "value": '289347298372',
//     "type": 'input',
//     "maxwidth": 300,
//     "error": '계좌번호(카드번호) 입력하세요.',
//     "placeholder": '1234567890',
//     "label": '계좌번호(카드번호)',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   },

//   "card_yy_mm": {
//     "value": null,
//     "type": 'input',
//     "formatter": InputFormatter().cardYYMM,
//     "maxwidth": 200,
//     "error": '카드유효기간을 정확하게 입력하세요.',
//     "placeholder": '11/29',
//     "label": '카드유효기간',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   },

//   //USIM INFO
//   "usim_plan_nm": {
//     //
//     "value": null,
//     "formatter": null,
//     "type": 'input',
//     "maxwidth": 400,
//     "error": '요금제을 선택하세요.',
//     "placeholder": '요금제 선택하세요.',
//     "label": '요금제',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "usim_model_list": {
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": 'USIM 모델명을 선택하세요.',
//     "placeholder": '모델명을 선택하세요',
//     "hasDefault": false,
//     "required": false,
//     "errorMessage": null,
//     "label": 'USIM 모델명',
//   },

//   "usim_no": {
//     "value": null, "formatter": null,
//     // "value": '12312312',
//     "type": 'input',
//     "maxwidth": 300,
//     "error": '일련번호 입력하세요.',
//     "placeholder": '00000000',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//     "label": '일련번호',
//   },
//   "usim_fee_cd": {
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '유심비용청구을 선택하세요',
//     "placeholder": '유심비용청구을 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "label": '유심비용청구',
//   },

//   "extra_service_cd": {
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '부가서비스 선택하세요',
//     "placeholder": '부가서비스을 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "label": '부가서비스',
//   },

//   "data_block_cd": {
//     "value": null,
//     "formatter": null,
//     "label": '데이터차단',
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '데이터 차단 서비스 선택하세요.',
//     "placeholder": '데이터 차단 서비스 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "data_roming_block_cd": {
//     "value": null,
//     "formatter": null,
//     "label": '해외데이터로밍',
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '해외데이터로밍을 선택하세요.',
//     "placeholder": '해외데이터로밍을 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "plan_fee_cd": {
//     "label": '가입비',
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '가입비을 선택하세요.',
//     "placeholder": '가입비을 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },
//   "phone_bill_block_cd": {
//     "label": '휴대폰결제',
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '휴대폰결제을 선택하세요.',
//     "placeholder": '휴대폰결제을 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },
//   "usim_act_cd": {
//     "label": '개통구분',
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '개통구분을 선택하세요.',
//     "placeholder": '개통구분을 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "wish_number": {
//     "label": '희망번호',
//     "value": null,
//     "formatter": InputFormatter().wishNumbmer,
//     "type": 'input',
//     "maxwidth": 300,
//     "error": null,
//     "placeholder": '희망번호',
//     "hasDefault": false,
//     "required": false,
//     "errorMessage": null,
//   },

//   "mnp_carrier_type": {
//     "label": '이동 유형',
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '이동 유형을 선택하세요.',
//     "placeholder": '선불',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "phone_number": {
//     "value": null,
//     "type": 'input',
//     "formatter": InputFormatter().phoneNumber010,
//     "initial": '010-',
//     "maxwidth": 300,
//     "error": '가입/이동 전화번호을 입력하세요.',
//     "placeholder": '010-0000-0000',
//     "label": '가입/이동 전화번호',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   },

//   "mnp_pre_carrier": {
//     "label": '이전통신사',
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 300,
//     "error": '이전통신사을 선택하세요.',
//     "placeholder": '선불',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "mnp_pre_carrier_nm": {
//     "value": null,
//     "formatter": null,
//     "type": 'input',
//     "maxwidth": 300,
//     "error": '이전 통신사 기타명을 입력하세요.',
//     "placeholder": '이전 통신사 기타명',
//     "label": '이전 통신사 기타명',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   },

//   "cust_type_cd": {
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 200,
//     "error": '고객유형 선택하세요.',
//     "placeholder": '고객유형 선택하세요',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "label": '고객유형',
//   },

//   "contact": {
//     "value": null,
//     "type": 'input',
//     "formatter": InputFormatter().phoneNumber,
//     // "initial": '010-1234-1234',
//     "initial": null,
//     "maxwidth": 200,
//     "error": '연락처 입력하세요.',
//     "placeholder": '010-0000-0000',
//     "label": '개통번호외 연락번호',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//   },

//   "country": {
//     "type": 'input',
//     "maxwidth": 300,
//     "error": '국적 선택하세요.',
//     "placeholder": '대한민국',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "value": null,
//     "formatter": null,
//     "label": '국적',
//   },

//   "id_no": {
//     //
//     "type": 'input',
//     "maxwidth": 200,
//     "error": '신분증번호/여권번호 입력하세요.',
//     "placeholder": '910131-0000000',
//     "value": null, "formatter": null,
//     // "value": '123214323',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "label": '신분증번호/여권번호',
//   },

//   "name": {
//     //
//     "type": 'input',
//     "maxwidth": 400,
//     "error": '가입자명 입력하세요.',
//     "placeholder": '홍길동',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "label": '가입자명',
//     "value": null, "formatter": null,
//     "capital": true,
//     // "value": 'TEST NAME',
//   },

//   "birthday": {
//     //
//     "type": 'input',
//     "formatter": InputFormatter().birthdayShort,
//     // "initial": '99-01-31',
//     "initial": null,
//     "maxwidth": 200,
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "error": '생년월일 입력하세요.',
//     "placeholder": '91-01-31',
//     "value": null,
//     "label": '생년월일',
//   },

//   "birthday_full": {
//     "type": 'input',
//     "formatter": InputFormatter().birthday,
//     // "initial": '1999-01-31',
//     "initial": null,
//     "maxwidth": 200,
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "error": '생년월일 입력하세요.',
//     "placeholder": '1991-01-31',
//     "value": null,
//     "label": '생년월일',
//   },

//   "gender_cd": {
//     "value": null,
//     "formatter": null,
//     "type": 'select',
//     "maxwidth": 100,
//     "error": '성별 입력하세요.',
//     "placeholder": '남',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "label": '성별',
//   },

//   "address": {
//     //
//     "value": null, "formatter": null,
//     "type": 'input',
//     "maxwidth": 400,
//     "error": '주소 입력하세요.',
//     "hasDefault": true,
//     "required": true,
//     "initial": null,
//     "errorMessage": null,
//     "placeholder": '서울시 구로구 디지털로33길 28',
//     "label": '주소',
//   },

//   "addressdetail": {
//     //
//     "value": null, "formatter": null,
//     "hasDefault": false,
//     "required": false,
//     "errorMessage": null,
//     "type": 'input',
//     "maxwidth": 300,
//     "error": null,
//     "placeholder": '우림이비지센터 1차 1210호',
//     "label": '상세주소',
//   },

//   "deputy_name": {
//     "label": '법정대리인 이름',
//     "value": null,
//     "formatter": null,
//     "type": 'input',
//     "maxwidth": 400,
//     "error": '법정대리인 이름 입력하세요.',
//     "placeholder": '법정대리인 이름',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//     "capital": true,
//   },

//   "deputy_birthday": {
//     "type": 'input',
//     "formatter": InputFormatter().birthdayShort,
//     "maxwidth": 200,
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "error": '법정대리인 생년월일 입력하세요.',
//     "placeholder": '91-01-31',
//     "value": null,
//     "label": '법정대리인 생년월일',
//   },

//   "deputy_birthday_full": {
//     "type": 'input',
//     "formatter": InputFormatter().birthday,
//     "maxwidth": 200,
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "error": '법정대리인 생년월일 입력하세요.',
//     "placeholder": '1991-01-31',
//     "value": null,
//     "label": '법정대리인 생년월일',
//   },

//   "relationship_cd": {
//     //
//     "value": null, "formatter": null,
//     "type": 'select',
//     "maxwidth": 100,
//     "error": '관계 선택하세요.',
//     "placeholder": '부',
//     "hasDefault": true,
//     "required": true,
//     "errorMessage": null,
//     "label": '관계',
//   },

//   "deputy_contact": {
//     "value": null,
//     "type": 'input',
//     "formatter": InputFormatter().phoneNumber,
//     "maxwidth": 200,
//     "error": '대리인 연락처 입력하세요.',
//     "placeholder": '010-0000-0000',
//     "label": '대리인 연락처',
//     "hasDefault": false,
//     "required": true,
//     "errorMessage": null,
//   }
// };
