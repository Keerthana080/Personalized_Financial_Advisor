import 'package:flutter/foundation.dart';

class SyncStatus {
  /// true  → syncing in progress
  /// false → sync finished
  static final ValueNotifier<bool> isSyncing = ValueNotifier<bool>(true);
}
