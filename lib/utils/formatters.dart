import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputFormatter {
  MaskTextInputFormatter createPhoneNumberFormatter() {
    return MaskTextInputFormatter(
      mask: '###-####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  var phoneNumber010 = MaskTextInputFormatter(
    // mask: '###-####-####',
    mask: '010-####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
    // initialText: '010-',
  );

  var phoneNumber = MaskTextInputFormatter(
    mask: '###-####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
    initialText: '010-',
  );

  var officeNumber = MaskTextInputFormatter(
    mask: '##-####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var officeFax = MaskTextInputFormatter(
    mask: '##-####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var birthday = MaskTextInputFormatter(
    mask: '####-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var birthdayShort = MaskTextInputFormatter(
    mask: '##-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var businessNumber = MaskTextInputFormatter(
    mask: '###-##-#####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var date = MaskTextInputFormatter(
    mask: '####-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  var wishNumbmer3 = MaskTextInputFormatter(
    mask: '###/####/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
    initialText: '',
  );

  var cardYYMM = MaskTextInputFormatter(
    mask: '##/## ',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
    initialText: '',
  );

  String validateAndCorrectDate(String dateStr) {
    if (dateStr.length == 10) {
      try {
        // Parse the input date string
        DateFormat('yyyy-MM-dd').parseStrict(dateStr);
        return dateStr; // Return the original string if valid
      } catch (e) {
        // Handle invalid date
        DateTime parsedDate;
        List<String> parts = dateStr.split('-');
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);

        // Adjust the date to the nearest valid date
        if (month < 1) {
          month = 1;
        } else if (month > 12) {
          month = 12;
        }
        while (true) {
          try {
            parsedDate = DateTime(year, month, day);
            break;
          } catch (e) {
            day -= 1;
            if (day < 1) {
              month -= 1;
              if (month < 1) {
                month = 12;
                year -= 1;
              }
              day = DateTime(year, month + 1, 0).day;
            }
          }
        }
        // Format the corrected date back to string
        return DateFormat('yyyy-MM-dd').format(parsedDate);
      }
    }
    return dateStr;
  }

  String validateAndCorrectShortDate(String dateStr) {
    if (dateStr.length == 8) {
      try {
        // Parse the input date string
        DateFormat('yy-MM-dd').parseStrict(dateStr);
        return dateStr; // Return the original string if valid
      } catch (e) {
        // Handle invalid date
        DateTime parsedDate;
        List<String> parts = dateStr.split('-');
        int year = int.parse(parts[0]);
        int month = int.parse(parts[1]);
        int day = int.parse(parts[2]);

        // Adjust the date to the nearest valid date
        if (month < 1) {
          month = 1;
        } else if (month > 12) {
          month = 12;
        }
        while (true) {
          try {
            parsedDate = DateTime(year, month, day);
            break;
          } catch (e) {
            day -= 1;
            if (day < 1) {
              month -= 1;
              if (month < 1) {
                month = 12;
                year -= 1;
              }
              day = DateTime(year, month + 1, 0).day;
            }
          }
        }
        // Format the corrected date back to string
        return DateFormat('yy-MM-dd').format(parsedDate);
      }
    }
    return dateStr;
  }

  String wonify(integerAmount) {
    if (integerAmount == null || integerAmount < 0) {
      integerAmount = 0;
    }

    String stringAmount = NumberFormat("#,###").format(integerAmount).toString();

    return ('₩ ${stringAmount.toString()}');
  }

  String? formatDate(String? dateTimeString) {
    if (dateTimeString != null) {
      // parsing the string into a DateTime object
      DateTime dateTime = DateTime.parse(dateTimeString);

      //  output format for a more readable date and time
      DateFormat outputFormat = DateFormat("yyyy-MM-dd");
      //  the DateTime object using the output format
      String formattedDateTime = outputFormat.format(dateTime);
      return formattedDateTime;
    }

    return null;
  }
}
