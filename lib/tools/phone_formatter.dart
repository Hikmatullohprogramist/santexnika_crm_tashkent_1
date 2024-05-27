import 'package:intl/intl.dart';

String formatPhoneNumber(String phoneNumber) {
  final NumberFormat numberFormat = NumberFormat('##0', 'en');

  // Ensure phoneNumber is not null and has at least 12 characters
  // if (phoneNumber == null || phoneNumber.length < 12) {
  //   return ''; // Or handle the error in another way
  // }

  try {
    // Check if phoneNumber is already formatted
    if (phoneNumber.startsWith('(') &&
        phoneNumber.contains(')') &&
        phoneNumber.contains('-')) {
      // Return the phone number as is since it's already formatted
      return phoneNumber;
    }

    // Extract substrings for different parts of the phone number
    String areaCode = phoneNumber.substring(4, 6);
    String firstPart = phoneNumber.substring(6, 9);
    String secondPart = phoneNumber.substring(9, 11);
    String secondPart1 = phoneNumber.substring(11, 13);

    // Format the phone number parts using the NumberFormat instance
    return '($areaCode) $firstPart-$secondPart-$secondPart1';
  } catch (e) {
    return ''; // Or handle the error in another way
  }
}

String phoneFormatter(int number) {
  String phoneNumber = number.toString();
  if (phoneNumber.length < 9) {
    return "Format noto'g'ri"; // Or return an appropriate default value
  }

  String formattedNumber =
      '${phoneNumber.substring(0, 2)} ${phoneNumber.substring(2, 5)} ${phoneNumber.substring(5, 7)} ${phoneNumber.substring(7, 9)}';

  return formattedNumber;
}
