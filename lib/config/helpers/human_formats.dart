

import 'package:intl/intl.dart';

// clase para dar formato a los numeros grandes 
class HumanFormats {

  static String number (double number, [int decimals = 0 ]) {

    return NumberFormat.compactCurrency(
      decimalDigits: decimals,
      symbol: '',
      locale: 'en'
    ).format(number);
  }

  static String shortDate( DateTime date ){
    final format = DateFormat.yMMMEd('es');
    return format.format(date);
  }

}