import 'dart:io';

import 'package:cli_util/cli_logging.dart' as cli;
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:logging/logging.dart';

import 'helpers/command_check.dart';
import 'shared/logger.dart';

void main(List<String> args) async {
  setUpLogger();

  var name = "check";
  cli.Logger verboselogger = args.contains('--verbose') ? cli.Logger.verbose() : cli.Logger.standard();
  Logger mainLogger = Logger(name);

  verboselogger.stdout("Checking that all necessary tools are here");
  await fetchWabt();

  await checkoutWabt();
}