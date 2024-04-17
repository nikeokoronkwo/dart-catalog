import 'dart:io';

import 'package:cli_util/cli_logging.dart' as cli;

import 'package:io/io.dart';
import 'package:logging/logging.dart';

import 'shared/logger.dart';
import 'shared/perform.dart';

void main(List<String> args) async {
  setUpLogger();

  var name = "check";
  cli.Logger verboselogger = args.contains('--verbose') ? cli.Logger.verbose() : cli.Logger.standard();
  Logger mainLogger = Logger(name);

  await fetchWabt(mainLogger, args, verboselogger);

  await updateWabt(mainLogger, args, verboselogger);

  exit(0);
}

Future<void> updateWabt(Logger logger, List<String> args, cli.Logger verboselogger) async {
  logger.info("Updating WABT Submodules");
  var manager = ProcessManager();
  await perform('git', [
      'submodule', 
      'update', 
      '--init'
  ], manager, logger, verboselogger, dir: args[0], error: "Failed to checkout Submodules for WABT");

  logger.fine("WABT Submodules Updated");
}

Future<void> fetchWabt(
  Logger logger, 
  List<String> args, 
  cli.Logger verboselogger
) async {
  logger.info("Fetching WABT");
  var manager = ProcessManager();
  if (!Directory(args[0]).existsSync()) await perform('git', [
      'clone', 
      'https://github.com/WebAssembly/wabt.git', 
      args[0]
    ], manager, logger, verboselogger, error: "Failed to fetch WABT from Git");
  else logger.fine("WABT already fetched");

  logger.fine("WABT Gotten");
}
