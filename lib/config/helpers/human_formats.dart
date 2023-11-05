

import 'package:intl/intl.dart';

// clase para dar formato a los numeros grandes 
class HumanFormats {

  static String number (double number, [int decimals = 0 ]) {

    final formattedNumber = NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en'
    ).format(number);

    return formattedNumber;
  }

}