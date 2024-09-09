// import 'package:intl/intl.dart';

// class CustomValidators {
//   String? validateId(String? value) {
//     value = value?.replaceAll(' ', ''); // remove spaces (if any)

//     // check if the field is empty
//     if (value == null || value.isEmpty) return '사용자 ID를 입력하세요.';

//     // check length (at least 4 characters)
//     if (value.length < 4) return '사용할 ID는 4자 이상';

//     // regular expression to match only English letters and digits
//     final isValidFormat = RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value);

//     if (!isValidFormat) return 'ID는 영문자와 숫자만 사용할 수 있습니다.';
//     // all checks passed
//     return null;
//   }

//   String? validateName(String? value) {
//     value = value?.replaceAll(' ', '');

//     // checking if the field is empty
//     if (value == null || value.isEmpty) return '이름을 입력하세요.';

//     return null;
//   }

//   String? validateEmail(String? value) {
//     value = value?.replaceAll(' ', '');

//     // checking if the field is empty
//     if (value == null || value.isEmpty) return '이메일을 입력하세요.';

//     final pattern = RegExp(r'^[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
//     if (!pattern.hasMatch(value)) {
//       return '올바르지 않은 이메일 형식입니다.';
//     }

//     return null;
//   }

//   String? validatePhoneNumber(String? value) {
//     value = value?.replaceAll(' ', '');

//     // checking if the field is empty
//     if (value == null || value.isEmpty) return '전화번호를 입력해주세요';

//     // regular expression to validate the phone number
//     final pattern = RegExp(r'^010-\d{4}-\d{4}$');
//     if (!pattern.hasMatch(value)) {
//       return '정확한 전화번호를 입력해주세요.';
//     }

//     return null;
//   }

//   String? validatePass(String? value) {
//     value = value?.replaceAll(' ', '');

//     // checking if the field is empty
//     if (value == null || value.isEmpty) return '비밀번호를 입력하세요.';

//     if (value.length < 8) {
//       return '비밀번호는 8자 이상 ';
//     }

//     final regex = RegExp(r'^(?=.*?[a-zA-Z])(?=.*?[0-9]){2}(?=.*?[!@#$&~*%^?]).{8,}$');

//     if (!regex.hasMatch(value)) {
//       return '비밀번호는 8자 이상, 대/소문자 1자, 숫자 2자 및 특수 대소문자 1자를 조합';
//     }

//     return null;
//   }

//   String? validateRentryPass(String? oldValue, String? newValue) {
//     newValue = newValue?.replaceAll(' ', '');

//     // checking if the field is empty
//     if (newValue == null || newValue.isEmpty) return '비밀번호를 다시 입력하세요.';

//     //matching old and new password
//     if (oldValue != newValue) return '비밀번호가 일치하지 않습니다.';

//     return null;
//   }

//   String? validateForNoneEmpty(String? value, String name) {
//     value = value?.replaceAll(' ', '');

//     if (value == null || value.isEmpty) {
//       return '$name 입력하세요.';
//     }

//     return null;
//   }

// //date as '24-08-31'
//   String? validateShortBirthday(String? value) {
//     // checking if the field is empty
//     if (value == null || value.isEmpty) return '생년월일 입력하세요.';

//     // Check if the format is correct (YY-MM-DD)
//     if (!RegExp(r'^\d{2}-\d{2}-\d{2}$').hasMatch(value)) {
//       return 'YY-MM-DD 형식으로 입력해주세요.';
//     }

//     return null;
//   }

// //date as '2024-08-31'
//   String? validateBirthday(String? value) {
//     value = value?.replaceAll(' ', '');

//     // checking if the field is empty
//     if (value == null || value.isEmpty) return '생년월일 입력하세요.';

//     // Check if the format is correct (YYYY-MM-DD)
//     if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
//       return 'YYYY-MM-DD 형식으로 입력해주세요.';
//     }

//     return null;
//   }

// //date as '08/31'
//   String? expiryDate(String? value) {
//     value = value?.replaceAll(' ', '');

//     // checking if the field is empty
//     if (value == null || value.isEmpty) return '카드유효기간을 입력하세요.';

//     // Check if the format is correct (MM/YY)
//     if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
//       return '카드유효기간을 정확하게 입력하세요.';
//     }

//     // splits into month and year
//     List<String> parts = value.split('/');

//     // Validate month
//     int monthInt = int.tryParse(parts[0]) ?? 0;
//     if (monthInt < 1 || monthInt > 12) {
//       return '잘못된 월입니다';
//     }

//     // // Validate year
//     if (parts[1].length == 2) {
//       int currentYear = int.parse(DateFormat('yy').format(DateTime.now()));
//       int yearInt = int.parse(parts[1]);
//       if (yearInt < currentYear) {
//         return '연도는 과거일 수 없습니다';
//       }
//     }

//     return null;
//   }

//   String? validateEmpty(String? value, String? error) {
//     value = value?.replaceAll(' ', '');

//     if (value == null || value.isEmpty) {
//       return error;
//     }

//     return null;
//   }

//   String? validate010phoneNumber(String? value, String error) {
//     // Remove all spaces from the input
//     value = value?.replaceAll(' ', '');

//     if (value == null || value.isEmpty) {
//       return error;
//     }

//     // Check if the format is correct (0XX-XXX-XXXX or 0XX-XXXX-XXXX)
//     if (!RegExp(r'^0\d{1,2}(-|)\d{3,4}-\d{4}$').hasMatch(value)) {
//       return '번호를 정확하게 입력하세요.';
//     }

//     return null;
//   }
// }
