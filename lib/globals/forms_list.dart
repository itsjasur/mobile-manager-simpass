Map inputFormsList = {
  //PAYMENT INFO
  "paid_transfer_cd": {
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '결제구분 선택하세요.',
    "placeholder": '결제구분 선택하세요',
    "label": '결제구분',
    "required": true,
  },

  "account_name": {
    "value": null,
    "type": 'input',
    // "value": 'TEST 예금주명',
    "maxwidth": 300,
    "errorMessage": '예금주명 입력하세요.',
    "placeholder": '홍길동',
    "label": '예금주명',
    "required": true,
    "capital": true,
  },

  "account_birthday": {
    "value": null,
    "type": 'input',
    // "value": '91-01-31',
    "maxwidth": 200,
    "errorMessage": '생년월일 입력하세요.',
    "placeholder": '91-01-31',
    "label": '예금주 생년월일',
    "required": true,
  },

  "account_agency": {
    // "value": 'TEST AGENCY',
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": '은행(카드사)명 입력하세요.',
    "placeholder": '하나은행',
    "label": '은행(카드사)명',
    "required": true,
  },

  "account_number": {
    "value": null,
    // "value": '289347298372',
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": '계좌번호(카드번호) 입력하세요.',
    "placeholder": '1234567890',
    "label": '계좌번호(카드번호)',
    "required": true,
  },

  "card_yy_mm": {
    "value": null,
    "type": 'input',
    "maxwidth": 200,
    "errorMessage": '카드유효기간을 정확하게 입력하세요.',
    "placeholder": '11/29',
    "label": '카드유효기간',
    "required": true,
  },

  //USIM INFO
  "usim_plan_nm": {
    //
    "value": null,
    "type": 'input',
    "maxwidth": 400,
    "errorMessage": '요금제을 선택하세요.',
    "placeholder": '요금제 선택하세요.',
    "label": '요금제',
    "required": true,
  },

  "usim_model_list": {
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": 'USIM 모델명을 선택하세요.',
    "placeholder": '모델명을 선택하세요',
    "required": false,
    "label": 'USIM 모델명',
  },

  "usim_no": {
    // "value": '12312312',
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": '일련번호 입력하세요.',
    "placeholder": '00000000',
    "required": true,
    "label": '일련번호',
  },
  "usim_fee_cd": {
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '유심비용청구을 선택하세요',
    "placeholder": '유심비용청구을 선택하세요',
    "required": true,
    "label": '유심비용청구',
  },

  "extra_service_cd": {
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '부가서비스 선택하세요',
    "placeholder": '부가서비스을 선택하세요',
    "required": true,
    "label": '부가서비스',
  },

  "data_block_cd": {
    "value": null,
    "label": '데이터차단',
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '데이터 차단 서비스 선택하세요.',
    "placeholder": '데이터 차단 서비스 선택하세요',
    "required": true,
  },

  "data_roming_block_cd": {
    "value": null,
    "label": '해외데이터로밍',
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '해외데이터로밍을 선택하세요.',
    "placeholder": '해외데이터로밍을 선택하세요',
    "required": true,
  },

  "plan_fee_cd": {
    "label": '가입비',
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '가입비을 선택하세요.',
    "placeholder": '가입비을 선택하세요',
    "required": true,
  },
  "phone_bill_block_cd": {
    "label": '휴대폰결제',
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '휴대폰결제을 선택하세요.',
    "placeholder": '휴대폰결제을 선택하세요',
    "required": true,
  },
  "usim_act_cd": {
    "label": '개통구분',
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '개통구분을 선택하세요.',
    "placeholder": '개통구분을 선택하세요',
    "required": true,
  },

  "wish_number": {
    "label": '희망번호',
    "value": null,
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": null,
    "placeholder": '희망번호',
    "required": false,
  },

  "mnp_carrier_type": {
    "label": '이동 유형',
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '이동 유형을 선택하세요.',
    "placeholder": '선불',
    "required": true,
  },

  "phone_number": {
    "value": null,
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": '가입/이동 전화번호을 입력하세요.',
    "placeholder": '010-0000-0000',
    "label": '가입/이동 전화번호',
    "required": true,
  },

  "mnp_pre_carrier": {
    "label": '이전통신사',
    "value": null,
    "type": 'select',
    "maxwidth": 300,
    "errorMessage": '이전통신사을 선택하세요.',
    "placeholder": '선불',
    "required": true,
  },

  "mnp_pre_carrier_nm": {
    "value": null,
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": '이전 통신사 기타명을 입력하세요.',
    "placeholder": '이전 통신사 기타명',
    "label": '이전 통신사 기타명',
    "required": true,
  },

  "cust_type_cd": {
    "value": null,
    "type": 'select',
    "maxwidth": 200,
    "errorMessage": '고객유형 선택하세요.',
    "placeholder": '고객유형 선택하세요',
    "required": true,
    "label": '고객유형',
  },

  "contact": {
    "value": null,
    "type": 'input',
    "maxwidth": 200,
    "errorMessage": '연락처 입력하세요.',
    "placeholder": '010-0000-0000',
    "label": '개통번호외 연락번호',
    "required": true,
  },

  "country": {
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": '국적 선택하세요.',
    "placeholder": '대한민국',
    "required": true,
    "value": null,
    "label": '국적',
  },

  "id_no": {
    //
    "type": 'input',
    "maxwidth": 200,
    "errorMessage": '신분증번호/여권번호 입력하세요.',
    "placeholder": '910131-0000000',
    // "value": '123214323',
    "required": true,
    "label": '신분증번호/여권번호',
  },

  "name": {
    //
    "type": 'input',
    "maxwidth": 400,
    "errorMessage": '가입자명 입력하세요.',
    "placeholder": '홍길동',
    "required": true,
    "label": '가입자명',
    "capital": true,
    // "value": 'TEST NAME',
  },

  "birthday": {
    //
    "type": 'input',
    "maxwidth": 200,
    "required": true,
    "errorMessage": '생년월일 입력하세요.',
    "placeholder": '91-01-31',
    "value": null,
    "label": '생년월일',
  },

  "gender_cd": {
    "value": null,
    "type": 'select',
    "maxwidth": 100,
    "errorMessage": '성별 입력하세요.',
    "placeholder": '남',
    "required": true,
    "label": '성별',
  },

  "address": {
    //
    "type": 'input',
    "maxwidth": 400,
    "errorMessage": '주소 입력하세요.',
    "required": true,
    "placeholder": '서울시 구로구 디지털로33길 28',
    "label": '주소',
  },

  "addressdetail": {
    //
    "required": false,
    "type": 'input',
    "maxwidth": 300,
    "errorMessage": null,
    "placeholder": '우림이비지센터 1차 1210호',
    "label": '상세주소',
  },

  "deputy_name": {
    "label": '법정대리인 이름',
    "value": null,
    "type": 'input',
    "maxwidth": 400,
    "errorMessage": '법정대리인 이름 입력하세요.',
    "placeholder": '법정대리인 이름',
    "required": true,
    "capital": true,
  },

  "deputy_birthday": {
    "type": 'input',
    "maxwidth": 200,
    "required": true,
    "errorMessage": '법정대리인 생년월일 입력하세요.',
    "placeholder": '91-01-31',
    "value": null,
    "label": '법정대리인 생년월일',
  },

  "relationship_cd": {
    //
    "type": 'select',
    "maxwidth": 100,
    "errorMessage": '관계 선택하세요.',
    "placeholder": '부',
    "required": true,
    "label": '관계',
  },

  "deputy_contact": {
    "value": null,
    "type": 'input',
    "maxwidth": 200,
    "errorMessage": '대리인 연락처 입력하세요.',
    "placeholder": '010-0000-0000',
    "label": '대리인 연락처',
    "required": true,
  }
};
