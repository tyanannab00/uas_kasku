import 'package:intl/intl.dart';

String formatRupiah(int value, {bool withSymbol = true}) {
  if (withSymbol) {
    final f = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return f.format(value);
  } else {
    final f = NumberFormat.decimalPattern('id_ID');
    return f.format(value);
  }
}
