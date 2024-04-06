import 'dart:io';

import 'package:cli_util/cli_logging.dart' as cli;
import 'package:logging/logging.dart';

import 'shared/logger.dart';
void main(List<String> args) async {
  setUpLogger();

  var name = "check";
  cli.Logger verboselogger = args.contains('--verbose') ? cli.Logger.verbose() : cli.Logger.standard();
  Logger mainLogger = Logger(name);

  verboselogger.stdout("Checking that all necessary tools are here");
  if (!Platform.isWindows) {
    await checkForMSVCOrMingw(mainLogger, args, verboselogger);
  }
}

Future<void> checkForMSVCOrMingw(Logger logger, List<String> args, cli.Logger verboselogger) async {
  logger.info("Checking whether Visual Studio is installed");
  var msvc = await Directory("C:\\Program Files (x86)\\Microsoft Visual Studio\\").exists();
  if (msvc) {
    logger.info("Visual Studio is installed");
    return;
  } else {
    logger.info("Visual Studio not installed");
  }
  logger.info("Checking whether MinGW is installed");
  
}