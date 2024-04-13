import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart' as cli;
import 'package:io/ansi.dart';

import 'package:io/io.dart';
import 'package:logging/logging.dart';

import 'shared/logger.dart';

void main(List<String> args) async {
  setUpLogger();

  var name = "check";
  cli.Logger verboselogger = args.contains('--verbose') ? cli.Logger.verbose() : cli.Logger.standard();
  Logger mainLogger = Logger(name);

  verboselogger.stdout("Checking that all necessary tools are here");
  await fetchWabt(mainLogger, args, verboselogger);
}

Future<void> fetchWabt(
  Logger logger, 
  List<String> args, 
  cli.Logger verboselogger
) async {
  logger.info("Checking out Wabt");
  var manager = ProcessManager();
  var result = await manager.spawnDetached(
    'git', [
      'clone', 
      'https://github.com/WebAssembly/wabt.git', 
      args[0]
    ]
  );
  result.stdout.transform(utf8.decoder).listen((event) {
    logger.config(event);
    verboselogger.trace(event);
  });
  result.stderr.transform(utf8.decoder).listen((event) {
    verboselogger.trace(red.wrap(event)!);
  });
  if (await result.exitCode != 0) {
    logger.severe("Failed to fetch WABT from Git: Process exited with exit code ${await result.exitCode}");
    logger.severe("Use --verbose to check messages");
    exit(1);
  }

  logger.fine("WABT Gotten");
  exit(0);
}


