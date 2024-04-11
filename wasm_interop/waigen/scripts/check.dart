import 'dart:io';

import 'package:cli_util/cli_logging.dart' as cli;
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:logging/logging.dart';

import 'helpers/command_check.dart';
import 'shared/logger.dart';

/// Args can be `--verbose`, `--top-level`, `--win`
void main(List<String> args) async {
  setUpLogger();

  var name = "check";
  cli.Logger verboselogger = args.contains('--verbose') ? cli.Logger.verbose() : cli.Logger.standard();
  Logger mainLogger = Logger(name);

  List<String> nothere = [];

  verboselogger.stdout("Checking that all necessary tools are here");
  if (Platform.isWindows || args.contains('--win')) {
    int ret = await checkForMSVCOrMingw(mainLogger, args, verboselogger);
    if (ret != 0) nothere.add('Visual Studio/MinGW');

    ret = await checkForCmake(mainLogger, args, verboselogger);
    if (ret != 0) nothere.add('CMake');

  } else if (args.contains('--top-level')) {
    List<int> ret = await checkForMakeAndNinja(mainLogger, args, verboselogger);
    if (ret.first != 0) nothere.add('GNU Make');
    if (ret.last != 0) nothere.add('Ninja');
  } else {
    int ret = await checkForCmake(mainLogger, args, verboselogger);
    if (ret != 0) nothere.add('CMake');
  }

  if (nothere.isNotEmpty) {
    mainLogger.severe("Error: Tools needed not installed! Please install required tools and try again.");
    mainLogger.severe("${styleBold.wrap("Requirements not installed:")} ${nothere.join(", ")}");
    verboselogger.trace("Check Failed with exit code 1: OUT");
    exit(1);
  } else {
    mainLogger.fine("All Tools needed Installed!");
    mainLogger.fine("Check Succeeded!");
    verboselogger.trace("Check Succeeded: OUT");
    exit(0);
  }

  
}

Future<int> checkForCmake(Logger logger, List<String> args, cli.Logger verboselogger) async {
  logger.info("Checking whether CMake is installed");
  var manager = ProcessManager();
  Process result;
  result = await checkCommand(manager, 'cmake');

  if (await result.exitCode == 0) {
    logger.fine("CMake Installed in the system");
    return 0;
  } else {
    logger.info("CMake not installed");
  }

  logger.severe("Error: CMake is not installed on your system.");
  
  return 1;
}

Future<List<int>> checkForMakeAndNinja(Logger mainLogger, List<String> args, cli.Logger verboselogger) async {
  int ret1 = await checkForMake(mainLogger, args, verboselogger);
  int ret2 = await checkForNinja(mainLogger, args, verboselogger);

  return [ret1, ret2];
}

Future<int> checkForNinja(Logger logger, List<String> args, cli.Logger verboselogger) async {
  logger.info("Checking whether Ninja is installed");
  var manager = ProcessManager();
  Process result;
  result = await checkCommand(manager, 'cmake');

  if (await result.exitCode == 0) {
    logger.fine("Ninja Installed in the system");
    return 0;
  } else {
    logger.info("Ninja not installed");
  }

  logger.severe("Error: Ninja is not installed on your system.");
  return 1;
}

Future<int> checkForMake(Logger logger, List<String> args, cli.Logger verboselogger) async {
  logger.info("Checking whether GNU Make is installed");
  var manager = ProcessManager();
  Process result;
  result = await checkCommand(manager, 'make');

  if (await result.exitCode == 0) {
    logger.fine("GNU Make Installed in the system");
    return 0;
  } else {
    logger.info("GNU Make not installed");
  }

  logger.severe("Error: GNU Make is not installed on your system.");
  return 1;
}

Future<int> checkForMSVCOrMingw(Logger logger, List<String> args, cli.Logger verboselogger) async {
  logger.info("Checking whether Visual Studio is installed");
  var msvc = await Directory("C:\\Program Files (x86)\\Microsoft Visual Studio\\").exists();
  if (msvc) {
    logger.fine("Visual Studio is installed");
    return 0;
  } else {
    logger.info("Visual Studio not installed");
  }
  logger.info("Checking whether MinGW is installed");
  var manager = ProcessManager(isWindows: true);
  Process? process;
  try {
    process = await manager.spawnDetached('scripts/helpers/check-mingw.bat', []);
  } on ProcessException catch (_) {
    logger.shout("Could not check for MinGW: Permission Denied");
    process = null;
  } catch (e) {
    process = null;
  }
  if (await process?.exitCode == 0) {
    logger.fine("MinGW is installed");
    return 0;
  } else {
    logger.info("MinGW not installed");
  }
  logger.severe("Error: Neither Visual Studio nor MinGW is installed on your system.");
  return 1;
}