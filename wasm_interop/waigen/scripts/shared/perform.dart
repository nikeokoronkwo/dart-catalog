import 'dart:convert';
import 'dart:io';
import 'package:cli_util/cli_logging.dart' as cli;
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:logging/logging.dart';

Future<void> perform(
  String command,
  List<String> arguments,
  ProcessManager manager, 
  Logger logger, 
  cli.Logger verboselogger, {
    String? dir,
    String error = "Unknown Error",
    bool warn = false,
    String? warnMsg,
    bool runInShell = false
}) async {
  var result = await manager.spawnDetached(
    command, arguments
  , workingDirectory: dir, runInShell: runInShell);
  result.stdout.transform(utf8.decoder).listen((event) {
    if (verboselogger is! cli.VerboseLogger) {
      logger.config(event.trim());
    } else {
      verboselogger.trace(event.trim());
    }
  });
  result.stderr.transform(utf8.decoder).listen((event) {
    verboselogger.trace(red.wrap(event)!);
  });
  if (await result.exitCode != 0) {
    if (warn) {
      logger.warning("$error: Process exited with exit code ${await result.exitCode}");
      if (verboselogger is! cli.VerboseLogger) logger.warning("Use --verbose to check messages");

      logger.warning(warnMsg);
    } else {
      logger.severe("$error: Process exited with exit code ${await result.exitCode}");
      if (verboselogger is! cli.VerboseLogger) logger.severe("Use --verbose to check messages");
      exit(1);
    }
  }
}


