import 'dart:developer';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class UpdateService {
  final _updater = ShorebirdUpdater();


  Future<bool> checkForUpdate() async {
    final status = await _updater.checkForUpdate();
    if (status == UpdateStatus.outdated) {
      log('Update available');
      return true;
    } else {
      log('App is up-to-date');
      return false;
    }
  }

  Future<void> downloadUpdate() async {
    await _updater.update();
    log('Update applied successfully');
  }
}