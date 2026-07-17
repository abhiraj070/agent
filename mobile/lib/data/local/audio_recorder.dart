import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// Thin wrapper around the `record` plugin: handles mic permission,
/// picks a temp file path per recording, and cleans up after upload.
///
/// Needs a platform permission entry once native projects exist —
/// `NSMicrophoneUsageDescription` in ios/Runner/Info.plist and
/// `android.permission.RECORD_AUDIO` in the Android manifest. Neither
/// exists yet since `flutter create .` hasn't been run against this
/// project; `hasPermission()`/`start()` will fail without them.
class AppAudioRecorder {
  AppAudioRecorder() : _recorder = AudioRecorder();

  final AudioRecorder _recorder;

  Future<bool> hasPermission() => _recorder.hasPermission();

  Future<void> start() async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/aaraam_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
  }

  /// Stops recording and returns the file path, or null if nothing was
  /// actually recorded.
  Future<String?> stop() => _recorder.stop();

  Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> dispose() => _recorder.dispose();
}
