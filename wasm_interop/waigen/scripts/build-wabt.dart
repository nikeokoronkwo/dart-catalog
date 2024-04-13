import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart' as cli;
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'helpers/command_check.dart';
import 'shared/logger.dart';

void main(List<String> args) async {
  setUpLogger();

  var name = "check";
  cli.Logger verboselogger = args.contains('--verbose') ? cli.Logger.verbose() : cli.Logger.standard();
  Logger mainLogger = Logger(name);

  verboselogger.stdout("Checking that all necessary tools are here");
  await buildWabt(mainLogger, args, verboselogger);

  await exportToPath(mainLogger, args, verboselogger);

  mainLogger.fine("Waigen is ready now!");
}

Future<void> exportToPath(
  Logger mainLogger, 
  List<String> args, 
  cli.Logger verboselogger
) async {
  mainLogger.info("Exporting to path");
  var manager = ProcessManager();
  if (args.contains('--win') || Platform.isWindows) {
    mainLogger.info("Exporting to path for Windows");
    var result = await manager.spawnDetached('setx', ['PATH', '"%PATH%;${p.absolute(args[0], 'build')}"']);
    result.stdout.transform(utf8.decoder).listen((event) {
      verboselogger.trace(event);
    });
    result.stderr.transform(utf8.decoder).listen((event) {
      verboselogger.trace(red.wrap(event)!);
    });
    if (await result.exitCode != 0) {
      mainLogger.severe("An error occured while adding to PATH: Process exited with exit code ${await result.exitCode}");
      mainLogger.severe("Use --verbose to check messages");
      exit(1);
    }
    mainLogger.warning("waigen is only temporarily added to your PATH (i.e for this session)");
    mainLogger.warning("To add permanently, add the path ${p.absolute(args[0], 'build')} to your PATH variable permanently.");
    mainLogger.fine("WABT Has been exported to your PATH. Great!");
    exit(0);

  } else {
    mainLogger.info("Exporting to path for ${Platform.isMacOS ? "MacOS" : "Linux"}");
    var result = await manager.spawnDetached('echo', ['"export \$PATH="\$PATH:"${p.absolute(args[0], 'build')}"" > ~/.${Platform.isLinux ? "bashrc" : "zshrc"}']);
    result.stdout.transform(utf8.decoder).listen((event) {
      verboselogger.trace(event);
    });
    result.stderr.transform(utf8.decoder).listen((event) {
      verboselogger.trace(red.wrap(event)!);
    });
    if (await result.exitCode != 0) {
      mainLogger.severe("An error occured while adding to PATH: Process exited with exit code ${await result.exitCode}");
      mainLogger.severe("Use --verbose to check messages");
      exit(1);
    }

    result = await manager.spawnDetached('source', ['~/.${Platform.isLinux ? "bashrc" : "zshrc"}']);
    result.stdout.transform(utf8.decoder).listen((event) {
      verboselogger.trace(event);
    });
    result.stderr.transform(utf8.decoder).listen((event) {
      verboselogger.trace(red.wrap(event)!);
    });
    if (await result.exitCode != 0) {
      mainLogger.severe("An error occured while adding to PATH: Process exited with exit code ${await result.exitCode}");
      mainLogger.severe("Use --verbose to check messages");
      exit(1);
    }

    mainLogger.fine("WABT Has been exported to your PATH. Great!");
  }
}

Future<void> buildWabt(
  Logger logger, 
  List<String> args, 
  cli.Logger verboselogger
) async {
  logger.info("Building Wabt");
  var manager = ProcessManager();
  if (args.contains('--top-level')) {
    logger.info("Building WABT Using Make and Ninja");
    var result = await manager.spawnDetached('make', [], workingDirectory: args[0]);
    result.stdout.transform(utf8.decoder).listen((event) {
      logger.config(event);
      verboselogger.trace(event);
    });
    result.stderr.transform(utf8.decoder).listen((event) {
      verboselogger.trace(red.wrap(event)!);
    });
    if (await result.exitCode != 0) {
      logger.severe("An error occured while building WABT with make and ninja: Process exited with exit code ${await result.exitCode}");
      logger.severe("Use --verbose to check messages");
      exit(1);
    }
    logger.fine("WABT Has been built. Great!");
  } else {
    logger.info("Building WABT Using CMake");
    var result = await manager.spawnDetached('mkdir', ['build'], workingDirectory: args[0]);
    result.stdout.transform(utf8.decoder).listen((event) {
      logger.config(event);
      verboselogger.trace(event);
    });
    result.stderr.transform(utf8.decoder).listen((event) {
      verboselogger.trace(red.wrap(event)!);
    });
    if (await result.exitCode != 0) {
      logger.severe("An unknown error occured: Process exited with exit code ${await result.exitCode}");
      logger.severe("Use --verbose to check messages");
      exit(1);
    }

    logger.info("Running CMake");
    List<String> cmakeArgs = [];
    if (args.contains('--win') || Platform.isWindows) {
      cmakeArgs.addAll([
      '-DCMAKE_BUILD_TYPE' '=' 'RELEASE', '-G', 'Visual Studio 17 2022', ...args.where((element) => element.startsWith('-D')).map((e) => e.split('=')).reduce((value, element) => [...value, ...element])
    ]);
    }
    result = await manager.spawnDetached('cmake', ['..'] + cmakeArgs, workingDirectory: p.join(args[0], 'build'));
    result.stdout.transform(utf8.decoder).listen((event) {
      logger.config(event);
      verboselogger.trace(event);
    });
    result.stderr.transform(utf8.decoder).listen((event) {
      verboselogger.trace(red.wrap(event)!);
    });
    if (await result.exitCode != 0) {
      logger.severe("An unknown error occured while running cmake: Process exited with exit code ${await result.exitCode}");
      logger.severe("Use --verbose to check messages");
      exit(1);
    }

    logger.info("Building using CMake");
    List<String> cmakeBuildArgs = [];
    if (args.contains('--win') || Platform.isWindows) {
      cmakeBuildArgs.addAll([
        '--config', 'RELEASE'
      ]);
    }
    result = await manager.spawnDetached('cmake', ['--build', '.'] + cmakeBuildArgs, workingDirectory: p.join(args[0], 'build'));
    result.stdout.transform(utf8.decoder).listen((event) {
      logger.config(event);
      verboselogger.trace(event);
    });
    result.stderr.transform(utf8.decoder).listen((event) {
      verboselogger.trace(red.wrap(event)!);
    });
    if (await result.exitCode != 0) {
      logger.severe("An unknown error occured while building with cmake: Process exited with exit code ${await result.exitCode}");
      logger.severe("Use --verbose to check messages");
      exit(1);
    }

    logger.fine("WABT Has been built. Great!");
  }
}