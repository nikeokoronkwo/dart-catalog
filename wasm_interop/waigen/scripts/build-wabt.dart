import 'dart:convert';
import 'dart:io';

import 'package:cli_util/cli_logging.dart' as cli;
import 'package:io/ansi.dart';
import 'package:io/io.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart' as p;

import 'helpers/command_check.dart';
import 'shared/logger.dart';
import 'shared/perform.dart';

void main(List<String> args) async {
  setUpLogger();

  var name = "check";
  cli.Logger verboselogger = args.contains('--verbose') ? cli.Logger.verbose() : cli.Logger.standard();
  Logger mainLogger = Logger(name);

  await buildWabt(mainLogger, args, verboselogger);

  await exportToPath(mainLogger, args, verboselogger);

  mainLogger.fine("Waigen is ready now!");
  exit(0);
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
    if (args.contains('--top-level') ) {
      var makeDir = Directory(p.join(args[0], 'out')).listSync().firstWhere((element) => element is Directory).absolute.path;
      await perform(
        'setx', 
        ['PATH', '"%PATH%;${p.normalize(p.join(makeDir, 'Debug'))}"'], 
        manager, mainLogger, verboselogger, 
        error: "An error occured while adding to PATH"
      );
    } else {
      await perform(
        'setx', 
        ['PATH', '"%PATH%;${p.normalize(p.absolute(args[0],'build'))}"'], 
        manager, mainLogger, verboselogger, 
        error: "An error occured while adding to PATH"
      );
    }
    mainLogger.warning("waigen is only temporarily added to your PATH (i.e for this session)");
    mainLogger.warning("To add permanently, add the path ${p.normalize(p.absolute(args[0], !args.contains('--top-level') ? 'build' : 'out'))} to your PATH variable permanently.");
    mainLogger.fine("WABT Has been exported to your PATH. Great!");
    exit(0);

  } else {
    mainLogger.info("Exporting to path for ${Platform.isMacOS ? "MacOS" : "Linux"}");
    if (args.contains('--top-level') ) {
      var makeDir = Directory(p.join(args[0], 'out')).listSync().firstWhere((element) => element is Directory).absolute.path;
      await addToPath(
        p.normalize(p.join(makeDir, 'Debug')),
        manager, mainLogger, verboselogger, args
      );
    } else {
      await addToPath(
        p.normalize(p.absolute(args[0], 'build')),
        manager, mainLogger, verboselogger, args
      );
    }

    String home = Platform.environment['HOME']!;
    await perform(
      'source', 
      ['$home/.${Platform.isLinux ? "bashrc" : "zshrc"}'], 
      manager, mainLogger, verboselogger,
      error: "An error occured while sourcing PATH",
      warn: true,
      warnMsg: "Run 'source ~/.${Platform.isLinux ? "bashrc" : "zshrc"} in order to effect the changes",
      runInShell: true
    );

    mainLogger.warning("Run 'source ~/.${Platform.isLinux ? "bashrc" : "zshrc"} in order to effect the changes");
    
    mainLogger.fine("WABT Has been exported to your PATH. Great!");
  }
}

Future<void> addToPath(String path, ProcessManager manager, Logger logger, cli.Logger verboselogger, List<String> args) async {
  String home = Platform.environment['HOME']!;
  try {
    
    File rcFile = File(Platform.isLinux ? '$home/.bashrc' : '$home/.zshrc');
    String contents = await rcFile.readAsString();
    contents += '\nexport PATH=${Platform.environment['PATH']}:$path';
    await rcFile.writeAsString(contents);
  } on Exception catch (e) {
    verboselogger.trace(e.toString());
    await perform(
      'echo', 
      ['"export \$PATH="\$PATH:"${p.normalize(p.absolute(args[0], !args.contains('--top-level') ? 'build' : 'out'))}""', '>>', '$home/.${Platform.isLinux ? "bashrc" : "zshrc"}'], 
      manager, logger, verboselogger,
      error: "An error occured while adding to PATH",
      runInShell: true
    );
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
    await perform('make', [], manager, logger, verboselogger, error: "An error occured while building WABT with make and ninja", dir: args[0]);
    logger.fine("WABT Has been built. Great!");
  } else {
    logger.info("Building WABT Using CMake");
    await perform('mkdir', ['build'], manager, logger, verboselogger, dir: args[0]);

    logger.info("Running CMake");
    List<String> cmakeArgs = [];
    if (args.contains('--win') || Platform.isWindows) {
      cmakeArgs.addAll([
        '-DCMAKE_BUILD_TYPE' '=' 'RELEASE', '-G', 'Visual Studio 17 2022'
      ]);
    }
    cmakeArgs.addAll(args.where((element) => element.startsWith('-D')));

    await perform('cmake', ['..'] + cmakeArgs, 
      manager, logger, verboselogger, 
      dir: p.join(args[0], 'build'),
      error: "An unknown error occured while running cmake"
    );

    logger.info("Building using CMake");
    List<String> cmakeBuildArgs = [];
    if (args.contains('--win') || Platform.isWindows) {
      cmakeBuildArgs.addAll([
        '--config', 'RELEASE'
      ]);
    }
    await perform('cmake', ['--build', '.'] + cmakeBuildArgs, 
      manager, logger, verboselogger, 
      dir: p.join(args[0], 'build'),
      error: "An unknown error occured while building with cmake"
    );

    logger.fine("WABT Has been built. Great!");
  }
}