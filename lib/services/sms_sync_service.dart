import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/background_parser.dart';
import 'package:flutter_application_1/services/sync_status.dart';
import 'package:hive/hive.dart';
import 'package:another_telephony/telephony.dart';
import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../models/raw_sms.dart';
import '../services/sms_filter.dart';
import '../services/sms_parser.dart';

class SmsSyncService {
  static final Telephony _telephony = Telephony.instance;

  // 🔴 DEBUG LOGGER (STATIC – IMPORTANT)
  static void logStep(String step) {
    debugPrint('🟡 STEP → $step');
  }

  static Future<void> syncOnce() async {
    logStep('syncOnce() START');

    final box = Hive.box<TransactionModel>('transactions');
    logStep('Hive box opened');

    if (box.isNotEmpty) {
      logStep('Hive already has data: ${box.length}');
      return;
    }

    logStep('Fetching SMS from Android');
    final smsList = await _telephony.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
    );
    logStep('SMS fetched');

    logStep('Total SMS: ${smsList.length}');

    // 🔴 CONVERT TO PURE DART OBJECTS
    logStep('Converting SmsMessage → RawSms');
    final List<RawSms> rawSmsList = smsList.map((sms) {
      return RawSms(
        address: sms.address ?? '',
        body: sms.body ?? '',
        date: DateTime.fromMillisecondsSinceEpoch(sms.date ?? 0),
      );
    }).toList();
    logStep('Converted to RawSms (${rawSmsList.length})');

    // 🔴 FILTER BANK SMS
    logStep('Filtering bank SMS');
    final List<RawSms> bankSms = filterBankSms(rawSmsList);
    logStep('Filtered bank SMS: ${bankSms.length}');

    int saved = 0;

    logStep('Starting background batch parse');

    final parsedList = await compute(parseSmsBatch, bankSms);

    logStep('Background parse complete: ${parsedList.length} items');

    for (final parsed in parsedList) {
      await box.add(
        TransactionModel(
          amount: parsed.amount,
          type: parsed.type,
          merchant: parsed.merchant,
          category: parsed.category,
          date: parsed.date,
        ),
      );
      saved++;

      if (saved % 25 == 0) {
        logStep('Saved $saved transactions');
      }
    }

    logStep('LOOP FINISHED');
    logStep('TOTAL SAVED: $saved');
    logStep('Hive count: ${box.length}');
    SyncStatus.isSyncing.value = false;
  }
}
