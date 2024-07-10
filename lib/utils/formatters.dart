import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class InputFormatter {
  var phoneNumber = MaskTextInputFormatter(
    mask: '###-####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
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

  String wonify(integerAmount) {
    if (integerAmount == null || integerAmount < 0) {
      integerAmount = 0;
    }

    String stringAmount = NumberFormat("#,###").format(integerAmount).toString();

    return ('₩ ${stringAmount.toString()}');
  }
}
