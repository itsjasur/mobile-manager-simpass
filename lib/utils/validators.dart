class InputValidator {
  String? validateId(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) return '사용자 ID를 입력하세요.';
    if (value.length < 4) {
      return '사용할 ID는 4자 이상';
    }

    return null;
  }

  String? validateEmployeeCode(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) return '영업사원코드 입력하세요.';
    if (value.length < 4) {
      return '영업사원코드는 4자 이상';
    }
    return null;
  }

  String? validateName(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) return '이름을 입력하세요.';

    return null;
  }

  String? validateEmail(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) return '이메일을 입력하세요.';

    // regular expression to validate the email
    final pattern = RegExp(r'^[a-zA-Z0-9+-_.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$');
    if (!pattern.hasMatch(value)) {
      return '올바르지 않은 이메일 형식입니다.';
    }

    return null;
  }

  String? validatePhoneNumber(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) return '전화번호를 입력해주세요';

    // regular expression to validate the email
    final pattern = RegExp(r'^010-\d{4}-\d{4}$');
    if (!pattern.hasMatch(value)) {
      return '정확한 전화번호를 입력해주세요.';
    }

    return null;
  }

  String? validatePass(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) return '비밀번호를 입력하세요.';

    if (value.length < 8) {
      return '비밀번호는 8자 이상 ';
    }

    final RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[0-9]){2}(?=.*?[!@#$&~*%^?]).{8,}$');
    if (!regex.hasMatch(value)) {
      return '비밀번호는 8자 이상, 대문자 1자, 숫자 2자 및 특수 대소문자 1자를 조합';
    }

    return null;
  }

  String? validateRentryPass(String? oldValue, String? newValue) {
    newValue = newValue?.replaceAll(' ', '');

    // checking if the field is empty
    if (newValue == null || newValue.isEmpty) return '비밀번호를 다시 입력하세요.';

    //matching old and new password
    if (oldValue != newValue) return '비밀번호가 일치하지 않습니다.';

    return null;
  }

  String? validateCountry(String? value) {
    value = value?.replaceAll(' ', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) return '국가를 선택하세요.';

    return null;
  }

  String? validateDateTime(String? value) {
    value = value?.replaceAll(' ', '');

    if (value == null || value.isEmpty) {
      return '날짜와 시간을 입력해주세요';
    }
    if (DateTime.tryParse(value) == null) {
      return '잘못된 날짜/시간 형식';
    }
    return null;
  }

  String? validateForNoneEmpty(String? value, String? name) {
    value = value?.replaceAll(' ', '');

    if (value == null || value.isEmpty) {
      return '$name 입력하세요.';
    }

    return null;
  }

  String? validateDate(String? value) {
    value = value?.replaceAll('-', '');

    // checking if the field is empty
    if (value == null || value.isEmpty) {
      return "날짜 입력하세요";
    }

    if (value.length >= 4) {
      int yyyy = int.parse(value.substring(0, 4));
      if (yyyy < 1900 || yyyy > 2025) {
        return "잘못된 날짜 연도 ";
      }
    }

    if (value.length >= 6) {
      int mm = int.parse(value.substring(4, 6));
      if (mm < 01 || mm > 12) {
        return "잘못된 날짜 월";
      }
    }

    if (value.length >= 8) {
      int dd = int.parse(value.substring(6, 8));
      if (dd < 01 || dd > 31) {
        return "잘못된 날짜 일";
      }
    }
    if (value.length < 8) {
      return "전체 날짜를 입력하세요.";
    }

    return null;
  }
}
