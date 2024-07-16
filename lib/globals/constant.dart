// ignore: constant_identifier_names
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mobile_manager_simpass/utils/formatters.dart';

const BASEURL = 'http://192.168.0.251:8091/api/';
// const BASEURL = 'https://ta.simpass.co.kr/api/';

final sideMenuNames = [
  '홈',
  '나의 정보',
  '가입/번호이동 신청서',
  '렌탈가입 신청서',
  '신청서 (접수/개통) 현황',
  '신청서양식 다운로드',
  '신청서 (접수/개통) 현황',
];

List plansFormsInfo = [
  {
    "code": 'PR',
    "carriers": [
      {
        "code": 'KT',
        "mvnos": [
          {
            "wishCount": 2,
            "code": 'COM',
            "customerForms": [
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'id_no',
              'country',
              'address',
              'addressdetail',
            ],
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_act_cd',
            ],
          },
        ],
      },
      {
        "code": 'LG',
        "mvnos": [
          {
            "wishCount": 3,
            "code": 'HPM',
            "customerForms": [
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'id_no',
              'country',
              'address',
              'addressdetail',
            ],
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_fee_cd',
              'usim_act_cd',
            ],
          },
          {
            "code": 'ISM',
            "wishCount": 3,
            "customerForms": [
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'id_no',
              'country',
              'address',
              'addressdetail',
            ],
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_act_cd',
            ],
          },
        ],
      },
    ],
  },
  {
    "code": 'PO',
    "paymentForms": [
      //
      'paid_transfer_cd',
      'account_name',
      'account_birthday',
      'account_agency',
      'account_number',
    ],

    // deputyForms: [
    //   //
    //   'deputy_name',
    //   'deputy_birthday',
    //   'relationship_cd',
    //   'deputy_contact',
    // ],
    "carriers": [
      {
        "code": 'SK',
        "mvnos": [
          {
            "wishCount": 2,
            "code": 'SVM',
            "customerForms": [
              //
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'address',
              'addressdetail',
            ],
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_fee_cd',
              'data_block_cd',
              'phone_bill_block_cd',
              'usim_act_cd',
            ],
          },
        ],
      },
      {
        "code": 'KT',
        "mvnos": [
          {
            "wishCount": 2,
            "code": 'KTM',
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_fee_cd',
              'data_block_cd',
              'phone_bill_block_cd',
              'plan_fee_cd',
              'usim_act_cd',
            ],
            "customerForms": [
              //
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'gender_cd',
              'address',
              'addressdetail',
            ],
          },
          {
            "code": 'KTS',
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'data_block_cd',
              'phone_bill_block_cd',
              'usim_act_cd',
            ],
            "customerForms": [
              //
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'address',
              'addressdetail',
            ],
          },
        ],
      },
      {
        "code": 'LG',
        "mvnos": [
          {
            "wishCount": 3,
            "code": 'HPM',
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_fee_cd',
              'usim_act_cd',
            ],
            "customerForms": [
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'id_no',
              'country',
              'address',
              'addressdetail',
            ],
          },
          {
            "wishCount": 2,
            "code": 'HVS',
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_fee_cd',
              'extra_service_cd',
              'data_roming_block_cd',
              'plan_fee_cd',
              'usim_act_cd',
            ],
            "customerForms": [
              //
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'address',
              'addressdetail',
              'gender_cd',
            ],
          },
          {
            "wishCount": 2,
            "code": 'UPM',
            "usimForms": [
              //
              'usim_plan_nm',
              'usim_model_list',
              'usim_no',
              'usim_fee_cd',
              'extra_service_cd',
              'data_roming_block_cd',
              'usim_act_cd',
            ],
            "customerForms": [
              //
              'cust_type_cd',
              'contact',
              'name',
              'birthday',
              'address',
              'addressdetail',
            ],
          },
        ],
      },
    ],
  },
];

Map inputFormsList = {
  //PAYMENT INFO
  "paid_transfer_cd": {
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '결제구분 선택하세요.',
    "placeholder": '결제구분 선택하세요',
    "label": '결제구분',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "account_name": {
    "value": null, "formatter": null,
    // "value": 'TEST 예금주명',
    "type": 'input',
    "maxwidth": 300,
    "error": '예금주명 입력하세요.',
    "placeholder": '홍길동',
    "label": '예금주명',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
    "capital": true,
  },

  "account_birthday": {
    "value": null,
    // "value": '91-01-31',
    "type": 'input',
    "formatter": InputFormatter().birthdayShort,
    "maxwidth": 200,
    "error": '생년월일 입력하세요.',
    "placeholder": '91-01-31',
    "label": '예금주 생년월일',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
  },

  "account_agency": {
    "value": null, "formatter": null,
    // "value": 'TEST AGENCY',
    "type": 'input',
    "maxwidth": 300,
    "error": '은행(카드사)명 입력하세요.',
    "placeholder": '하나은행',
    "label": '은행(카드사)명',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
  },

  "account_number": {
    "value": null,
    "formatter": FilteringTextInputFormatter.digitsOnly,

    // "value": '289347298372',
    "type": 'input',
    "maxwidth": 300,
    "error": '계좌번호(카드번호) 입력하세요.',
    "placeholder": '1234567890',
    "label": '계좌번호(카드번호)',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
  },

  "card_yy_mm": {
    "value": null,
    "type": 'input',
    "formatter": InputFormatter().cardYYMM,
    "maxwidth": 200,
    "error": '카드유효기간을 정확하게 입력하세요.',
    "placeholder": '11/29',
    "label": '카드유효기간',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
  },

  //USIM INFO
  "usim_plan_nm": {
    //
    "value": null,
    "formatter": null,
    "type": 'input',
    "maxwidth": 400,
    "error": '요금제을 선택하세요.',
    "placeholder": '요금제 선택하세요.',
    "label": '요금제',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "usim_model_list": {
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": 'USIM 모델명을 선택하세요.',
    "placeholder": '모델명을 선택하세요',
    "hasDefault": false,
    "required": false,
    "errorMessage": null,
    "label": 'USIM 모델명',
  },

  "usim_no": {
    "value": null, "formatter": null,
    // "value": '12312312',
    "type": 'input',
    "maxwidth": 300,
    "error": '일련번호 입력하세요.',
    "placeholder": '00000000',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
    "label": '일련번호',
  },
  "usim_fee_cd": {
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '유심비용청구을 선택하세요',
    "placeholder": '유심비용청구을 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "label": '유심비용청구',
  },

  "extra_service_cd": {
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '부가서비스 선택하세요',
    "placeholder": '부가서비스을 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "label": '부가서비스',
  },

  "data_block_cd": {
    "value": null,
    "formatter": null,
    "label": '데이터차단',
    "type": 'select',
    "maxwidth": 300,
    "error": '데이터 차단 서비스 선택하세요.',
    "placeholder": '데이터 차단 서비스 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "data_roming_block_cd": {
    "value": null,
    "formatter": null,
    "label": '해외데이터로밍',
    "type": 'select',
    "maxwidth": 300,
    "error": '해외데이터로밍을 선택하세요.',
    "placeholder": '해외데이터로밍을 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "plan_fee_cd": {
    "label": '가입비',
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '가입비을 선택하세요.',
    "placeholder": '가입비을 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },
  "phone_bill_block_cd": {
    "label": '휴대폰결제',
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '휴대폰결제을 선택하세요.',
    "placeholder": '휴대폰결제을 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },
  "usim_act_cd": {
    "label": '개통구분',
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '개통구분을 선택하세요.',
    "placeholder": '개통구분을 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "wish_number": {
    "label": '희망번호',
    "value": null,
    "formatter": InputFormatter().wishNumbmer3,
    "type": 'input',
    "maxwidth": 300,
    "error": null,
    "placeholder": '희망번호',
    "hasDefault": false,
    "required": false,
    "errorMessage": null,
  },

  "mnp_carrier_type": {
    "label": '이동 유형',
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '이동 유형을 선택하세요.',
    "placeholder": '선불',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "phone_number": {
    "value": null,
    "type": 'input',
    "formatter": InputFormatter().phoneNumber010,
    "initial": '010-',
    "maxwidth": 300,
    "error": '가입/이동 전화번호을 입력하세요.',
    "placeholder": '010-0000-0000',
    "label": '가입/이동 전화번호',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
  },

  "mnp_pre_carrier": {
    "label": '이전통신사',
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 300,
    "error": '이전통신사을 선택하세요.',
    "placeholder": '선불',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "mnp_pre_carrier_nm": {
    "value": null,
    "formatter": null,
    "type": 'input',
    "maxwidth": 300,
    "error": '이전 통신사 기타명을 입력하세요.',
    "placeholder": '이전 통신사 기타명',
    "label": '이전 통신사 기타명',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
  },

  "cust_type_cd": {
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 200,
    "error": '고객유형 선택하세요.',
    "placeholder": '고객유형 선택하세요',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "label": '고객유형',
  },

  "contact": {
    "value": null,
    "type": 'input',
    "formatter": InputFormatter().phoneNumber,
    "initial": '010-1234-1234',
    "maxwidth": 200,
    "error": '연락처 입력하세요.',
    "placeholder": '010-0000-0000',
    "label": '개통번호외 연락번호',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
  },

  "country": {
    "type": 'input',
    "maxwidth": 300,
    "error": '국적 선택하세요.',
    "placeholder": '대한민국',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "value": null,
    "formatter": null,
    "label": '국적',
  },

  "id_no": {
    //
    "type": 'input',
    "maxwidth": 200,
    "error": '신분증번호/여권번호 입력하세요.',
    "placeholder": '910131-0000000',
    "value": null, "formatter": null,
    // "value": '123214323',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "label": '신분증번호/여권번호',
  },

  "name": {
    //
    "type": 'input',
    "maxwidth": 400,
    "error": '가입자명 입력하세요.',
    "placeholder": '홍길동',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "label": '가입자명',
    "value": null, "formatter": null,
    "capital": true,
    // "value": 'TEST NAME',
  },

  "birthday": {
    //
    "type": 'input',
    "formatter": InputFormatter().birthdayShort,
    "initial": '99-01-31',
    "maxwidth": 200,
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "error": '생년월일 입력하세요.',
    "placeholder": '91-01-31',
    "value": null,
    "label": '생년월일',
  },

  "gender_cd": {
    "value": null,
    "formatter": null,
    "type": 'select',
    "maxwidth": 100,
    "error": '성별 입력하세요.',
    "placeholder": '남',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "label": '성별',
  },

  "address": {
    //
    "value": null, "formatter": null,
    "type": 'input',
    "maxwidth": 400,
    "error": '주소 입력하세요.',
    "hasDefault": true,
    "required": true,
    "initial": 'test temp address',
    "errorMessage": null,
    "placeholder": '서울시 구로구 디지털로33길 28',
    "label": '주소',
  },

  "addressdetail": {
    //
    "value": null, "formatter": null,
    "hasDefault": false,
    "required": false,
    "errorMessage": null,
    "type": 'input',
    "maxwidth": 300,
    "error": null,
    "placeholder": '우림이비지센터 1차 1210호',
    "label": '상세주소',
  },

  "deputy_name": {
    "label": '법정대리인 이름',
    "value": null,
    "formatter": null,
    "type": 'input',
    "maxwidth": 400,
    "error": '법정대리인 이름 입력하세요.',
    "placeholder": '법정대리인 이름',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
    "capital": true,
  },

  "deputy_birthday": {
    "type": 'input',
    "formatter": InputFormatter().birthdayShort,
    "maxwidth": 200,
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "error": '법정대리인 생년월일 입력하세요.',
    "placeholder": '91-01-31',
    "value": null,
    "label": '법정대리인 생년월일',
  },

  "relationship_cd": {
    //
    "value": null, "formatter": null,
    "type": 'select',
    "maxwidth": 100,
    "error": '관계 선택하세요.',
    "placeholder": '부',
    "hasDefault": true,
    "required": true,
    "errorMessage": null,
    "label": '관계',
  },

  "deputy_contact": {
    "value": null,
    "type": 'input',
    "formatter": InputFormatter().phoneNumber,
    "maxwidth": 200,
    "error": '대리인 연락처 입력하세요.',
    "placeholder": '010-0000-0000',
    "label": '대리인 연락처',
    "hasDefault": false,
    "required": true,
    "errorMessage": null,
  }
};

// class forms {
//   late dynamic paid_transfer_cd;
//   late dynamic account_name;
//   late dynamic account_birthday;
//   late dynamic account_agency;
//   late dynamic account_number;
//   late dynamic card_yy_mm;
//   late dynamic usim_plan_nm;
//   late dynamic usim_model_list;
//   late dynamic usim_no;
//   late dynamic usim_fee_cd;
//   late dynamic extra_service_cd;
//   late dynamic data_block_cd;
//   late dynamic data_roming_block_cd;
//   late dynamic plan_fee_cd;
//   late dynamic phone_bill_block_cd;
//   late dynamic usim_act_cd;
//   late dynamic wish_number;
//   late dynamic mnp_carrier_type;
//   late dynamic phone_number;
//   late dynamic mnp_pre_carrier;
//   late dynamic mnp_pre_carrier_nm;
//   late dynamic cust_type_cd;
//   late dynamic contact;
//   late dynamic country;
//   late dynamic id_no;
//   late dynamic name;
//   late dynamic birthday;
//   late dynamic gender_cd;
//   late dynamic address;
//   late dynamic addressdetail;
//   late dynamic deputy_name;
//   late dynamic deputy_birthday;
//   late dynamic relationship_cd;
//   late dynamic deputy_contact;
// }

class FormStructure {
  TextEditingController value;
  String type;
  dynamic formatter;
  String placeholder;
  String label;
  bool? required;
  int maxwidth;
  String? error;
  bool? hasDefault;
  bool? capital;
  String? errorMessage;

  FormStructure({
    required this.value,
    required this.type,
    this.formatter,
    required this.maxwidth,
    required this.error,
    required this.placeholder,
    required this.label,
    required this.hasDefault,
    required this.required,
    this.errorMessage,
    this.capital,
  });

  // Factory constructor to create a FormStructure from a Map
  factory FormStructure.fromMap(Map<String, dynamic> map) {
    return FormStructure(
      value: map['value'] as TextEditingController,
      type: map['type'],
      formatter: map['formatter'],
      maxwidth: map['maxwidth'],
      error: map['error'],
      placeholder: map['placeholder'],
      label: map['label'],
      hasDefault: map['hasDefault'],
      required: map['required'],
      errorMessage: map['errorMessage'],
      capital: map['capital'],
    );
  }
}

// class InputFormsList {
//   final Map<String, FormStructure> structure;

//   InputFormsList(this.structure);

//   // Custom getter to access the FormStructure map using the name as a key
//   FormStructure? operator [](String key) {
//     return structure[key];
//   }
// }

class InputFormsList {
  final Map<String, Map<String, dynamic>> structure;

  InputFormsList(this.structure);

  // Custom getter to access the FormStructure map using the name as a key
  FormStructure? operator [](String key) {
    if (structure.containsKey(key)) {
      return FormStructure.fromMap(structure[key]!);
    }
    return null;
  }
}
