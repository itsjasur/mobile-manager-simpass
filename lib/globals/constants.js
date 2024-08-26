export const SIDEMENUNAMES = [
  '홈',
  '나의 정보',
  '가입/번호이동 신청서',
  '신청서 (접수/개통) 현황',
  '신청서양식 다운로드',
  '신청서 (접수/개통) 현황',
]

export const BASEURL = import.meta.env.DEV ? 'http://192.168.0.251:8091/api/' : 'https://ta.simpaass.co.kr/api/'
// export const import.meta.env.VITE_API_BASE_URL = 'https://ta.simpass.co.kr/api/'

export const PLANTYPES = [
  { cd: 'PO', label: '후불' },
  { cd: 'PR', label: '선불' },
]

export const CARRIERS = [
  { cd: '', label: '전체' },
  { cd: 'KT', label: 'KT' },
  { cd: 'SK', label: 'SKT' },
  { cd: 'LG', label: 'LG U+' },
]

export const EMAILOPTIONS = [
  { value: '', label: '직접입력' },
  { value: '@naver.com', label: '@naver.com' },
  { value: '@daum.net', label: '@daum.net' },
  { value: '@kakao.com', label: '@kakao.com' },
  { value: '@gmail.com', label: '@gmail.com' },
  { value: '@hanmail.net', label: '@hanmail.net' },
  { value: '@hotmail.com', label: '@hotmail.com' },
]

import * as cleavePatterns from '../utils/cleavePatterns'
import { reactive } from 'vue'

export const FORMS = reactive({
  //PAYMENT FORMS
  paid_transfer_cd: {
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '결제구분 선택하세요.',
    placeholder: '결제구분 선택하세요',
    label: '결제구분',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  account_name: {
    value: null,
    // value: 'TEST 예금주명',
    type: 'input',
    maxwidth: '180px',
    error: '예금주명 입력하세요.',
    placeholder: '홍길동',
    label: '예금주명',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  account_birthday: {
    value: null,
    // value: '91-01-31',
    type: 'cleave',
    pattern: cleavePatterns.birthdayPattern,
    maxwidth: '150px',
    error: '생년월일 입력하세요.',
    placeholder: '91-01-31',
    label: '예금주 생년월일',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },
  account_birthday_full: {
    value: null,
    // value: '91-01-31',
    type: 'cleave',
    pattern: cleavePatterns.birthdayPatternFull,
    maxwidth: '150px',
    error: '생년월일 입력하세요.',
    placeholder: '1991-01-31',
    label: '예금주 생년월일',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  account_agency: {
    value: null,
    // value: 'TEST AGENCY',
    type: 'input',
    maxwidth: '180px',
    error: '은행(카드사)명 입력하세요.',
    placeholder: '하나은행',
    label: '은행(카드사)명',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  account_number: {
    value: null,
    // value: '289347298372',
    type: 'input',
    maxwidth: '180px',
    error: '계좌번호(카드번호) 입력하세요.',
    placeholder: '1234567890',
    label: '계좌번호(카드번호)',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  card_yy_mm: {
    value: null,
    type: 'cleave',
    pattern: {
      date: true,
      datePattern: ['m', 'y'],
      dateMin: '06/24',
    },
    maxwidth: '200px',
    error: '카드유효기간을 정확하게 입력하세요.',
    placeholder: '11/29',
    label: '카드유효기간 (MM/YY)',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  //USIM INFO
  usim_plan_nm: {
    //
    value: null,
    type: 'input',
    maxwidth: '400px',
    error: '요금제을 선택하세요.',
    placeholder: '요금제 선택하세요.',
    label: '요금제',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  usim_model_list: {
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: 'USIM 모델명을 선택하세요.',
    placeholder: '모델명을 선택하세요',
    hasDefault: false,
    required: false,
    errorMessage: null,
    label: 'USIM 모델명',
  },

  usim_no: {
    value: null,
    // value: '12312312',
    type: 'input',
    maxwidth: '180px',
    error: '일련번호 입력하세요.',
    placeholder: '00000000',
    hasDefault: false,
    required: true,
    errorMessage: null,
    label: 'USIM 일련번호',
  },
  usim_fee_cd: {
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '유심비용청구을 선택하세요',
    placeholder: '유심비용청구을 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
    label: '유심비용청구',
  },

  //EXTRA
  extra_service_cd: {
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '부가서비스 선택하세요',
    placeholder: '부가서비스을 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
    label: '부가서비스',
  },

  data_block_cd: {
    value: null,
    label: '데이터차단',
    type: 'select',
    maxwidth: '180px',
    error: '데이터 차단 서비스 선택하세요.',
    placeholder: '데이터 차단 서비스 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  data_roming_block_cd: {
    value: null,
    label: '해외데이터로밍',
    type: 'select',
    maxwidth: '180px',
    error: '해외데이터로밍을 선택하세요.',
    placeholder: '해외데이터로밍을 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  plan_fee_cd: {
    label: '가입비',
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '가입비을 선택하세요.',
    placeholder: '가입비을 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },
  phone_bill_block_cd: {
    label: '휴대폰결제',
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '휴대폰결제을 선택하세요.',
    placeholder: '휴대폰결제을 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },
  usim_act_cd: {
    label: '개통구분',
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '개통구분을 선택하세요.',
    placeholder: '개통구분을 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  wish_number: {
    label: '희망번호',
    value: null,
    type: 'cleave',
    maxwidth: '180px',
    error: null,
    placeholder: '희망번호',
    hasDefault: false,
    required: false,
    errorMessage: null,
  },

  mnp_carrier_type: {
    label: '이동 유형',
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '이동 유형을 선택하세요.',
    placeholder: '선불',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  phone_number: {
    value: null,
    type: 'cleave',
    pattern: {
      prefix: '010-',
      phone: true,
      phoneRegionCode: 'KR',
      delimiter: '-',
    },
    maxwidth: '180px',
    error: '가입/이동 전화번호을 입력하세요.',
    placeholder: '010-0000-0000',
    label: '가입/이동 전화번호',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  mnp_pre_carrier: {
    label: '이전통신사',
    value: null,
    type: 'select',
    maxwidth: '180px',
    error: '이전통신사을 선택하세요.',
    placeholder: '선불',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  mnp_pre_carrier_nm: {
    value: null,
    type: 'input',
    maxwidth: '200px',
    error: '이전 통신사 기타명을 입력하세요.',
    placeholder: '이전 통신사 기타명',
    label: '이전 통신사 기타명',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  //CUSTOMER FORMS

  cust_type_cd: {
    value: null,
    type: 'select',
    maxwidth: '200px',
    error: '고객유형 선택하세요.',
    placeholder: '고객유형 선택하세요',
    hasDefault: true,
    required: true,
    errorMessage: null,
    label: '고객유형',
  },

  contact: {
    value: null,
    // value: '010-1234-1234',
    type: 'cleave',
    pattern: {
      phone: true,
      phoneRegionCode: 'KR',
      delimiter: '-',
    },
    maxwidth: '200px',
    error: '연락처 입력하세요.',
    placeholder: '010-0000-0000',
    label: '개통번호외 연락번호',
    hasDefault: true,
    required: true,
    errorMessage: null,
  },

  country: {
    type: 'input',
    maxwidth: '180px',
    error: '국적 선택하세요.',
    placeholder: '대한민국',
    hasDefault: true,
    required: true,
    errorMessage: null,
    value: null,
    label: '국적',
  },

  id_no: {
    //
    type: 'input',
    maxwidth: '200px',
    error: '신분증번호/여권번호 입력하세요.',
    placeholder: '910131-0000000',
    value: null,
    // value: '123214323',
    hasDefault: true,
    required: true,
    errorMessage: null,
    label: '신분증번호/여권번호',
  },

  name: {
    //
    type: 'input',
    maxwidth: '400px',
    error: '가입자명 입력하세요.',
    placeholder: '홍길동',
    hasDefault: true,
    required: true,
    errorMessage: null,
    label: '가입자명',
    value: null,
    // value: 'TEST NAME',
  },

  birthday: {
    //
    type: 'cleave',
    pattern: cleavePatterns.birthdayPattern,
    maxwidth: '150px',
    hasDefault: true,
    required: true,
    errorMessage: null,
    error: '생년월일 입력하세요.',
    placeholder: '91-01-31',
    value: null,
    // value: '99-01-12',
    label: '생년월일',
  },
  birthday_full: {
    //
    type: 'cleave',
    pattern: cleavePatterns.birthdayPatternFull,
    maxwidth: '150px',
    hasDefault: true,
    required: true,
    errorMessage: null,
    error: '생년월일 입력하세요.',
    placeholder: '1991-01-31',
    value: null,
    label: '생년월일',
  },

  gender_cd: {
    value: null,
    type: 'select',
    maxwidth: '100px',
    error: '성별 입력하세요.',
    placeholder: '남',
    hasDefault: true,
    required: true,
    errorMessage: null,
    label: '성별',
  },

  address: {
    //
    value: null,
    type: 'input',
    maxwidth: '400px',
    error: '주소 입력하세요.',
    hasDefault: true,
    required: true,
    errorMessage: null,
    placeholder: '서울시 구로구 디지털로33길 28',
    label: '주소',
  },

  addressdetail: {
    //
    value: null,
    hasDefault: false,
    required: false,
    errorMessage: null,
    type: 'input',
    maxwidth: '200px',
    error: null,
    placeholder: '우림이비지센터 1차 1210호',
    label: '상세주소',
  },

  //DEPUTY FORMS

  deputy_name: {
    label: '법정대리인 이름',
    value: null,
    type: 'input',
    maxwidth: '400px',
    error: '법정대리인 이름 입력하세요.',
    placeholder: '법정대리인 이름',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },

  deputy_birthday: {
    type: 'cleave',
    pattern: cleavePatterns.birthdayPattern,
    maxwidth: '150px',
    hasDefault: true,
    required: true,
    errorMessage: null,
    error: '법정대리인 생년월일 입력하세요.',
    placeholder: '91-01-31',
    value: null,
    label: '법정대리인 생년월일',
  },
  deputy_birthday_full: {
    type: 'cleave',
    pattern: cleavePatterns.birthdayPatternFull,
    maxwidth: '150px',
    hasDefault: true,
    required: true,
    errorMessage: null,
    error: '법정대리인 생년월일 입력하세요.',
    placeholder: '1991-01-31',
    value: null,
    label: '법정대리인 생년월일',
  },

  relationship_cd: {
    //
    value: null,
    type: 'select',
    maxwidth: '100px',
    error: '관계 선택하세요.',
    placeholder: '부',
    hasDefault: true,
    required: true,
    errorMessage: null,
    label: '관계',
  },

  deputy_contact: {
    value: null,
    type: 'cleave',
    pattern: {
      phone: true,
      phoneRegionCode: 'KR',
      delimiter: '-',
    },
    maxwidth: '200px',
    error: '대리인 연락처 입력하세요.',
    placeholder: '010-0000-0000',
    label: '대리인 연락처',
    hasDefault: false,
    required: true,
    errorMessage: null,
  },
})

// const emailOptions = [
//   { value: '@kakao.com', label: '@kakao.com' },
//   { value: '@daum.net', label: '@daum.net' },
//   { value: '@hanmail.net', label: '@hanmail.net' },
//   { value: '@gmail.com', label: '@gmail.com' },
//   { value: '@hotmail.com', label: '@hotmail.com' },
//   { value: '@naver.com', label: '@naver.com' },
//   { value: null, label: '직접입력' },
// ]
