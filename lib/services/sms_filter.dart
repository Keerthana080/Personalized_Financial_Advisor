import 'package:flutter_application_1/models/raw_sms.dart';

List<RawSms> filterBankSms(List<RawSms> allSms) {
  return allSms.where((sms) {
    final body = sms.body.toLowerCase();

    final hasAmount = RegExp(r'(rs\.?|rs:|inr|₹)\s*\d+(\.\d+)?').hasMatch(body);

    final isTransaction =
        body.contains('credited') ||
        body.contains('debited') ||
        body.contains('withdrawn') ||
        body.contains('spent');

    final isPromo =
        body.contains('offer') ||
        body.contains('cashback') ||
        body.contains('discount') ||
        body.contains('otp') ||
        body.contains('reward');

    return hasAmount && isTransaction && !isPromo;
  }).toList();
}
