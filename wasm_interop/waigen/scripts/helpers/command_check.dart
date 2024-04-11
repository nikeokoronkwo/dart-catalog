import 'dart:io';
import 'package:io/io.dart';


Future<Process> checkCommand(ProcessManager manager, String command) async {
  if (!Platform.isWindows) {
    return await manager.spawnDetached('command', ['-v', command], runInShell: true);
  } else {
    return await manager.spawnDetached('Get-Command', [command]);
  }
}
