// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:io/io.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) {
  final results = parser.parse(args);
  if (results.wasParsed('help')) {
    printUsage(parser);
    return;
  }
  if (results.wasParsed('version')) {
    printVersion();
    return;
  }
  handle(results, parser);
  return;
}

final _waigenDef = '${Platform.environment['HOME']}/.pub-cache/waigen';

/// TODO: Implement
void _makeWaigenDef() => Directory(_waigenDef).createSync(recursive: true);

final parser = ArgParser()
  ..addFlag('help', abbr: 'h', help: 'Show this help message', negatable: false)
  ..addFlag('version', abbr: 'V', help: 'Show version', negatable: false)
  ..addFlag('verbose', abbr: 'v', help: 'Produce verbose logging', negatable: false)
  ..addFlag('only-required', help: 'Save only required tools', negatable: false)
  ..addFlag('cmake', help: 'Whether to use cmake for building the project', defaultsTo: true, negatable: true)
  ..addOption('output', abbr: 'o', defaultsTo: '.', help: 'Output directory')
  ..addFlag('check', abbr: 'c', help: 'Check if necessary tools are present on system', negatable: false)
  ..addMultiOption('cmake-flags', help: "Pass the given flags to CMake [e.g -cmake-flags CMAKE_C_COMPILER=clang] (separate with commas)", defaultsTo: [], splitCommas: true, valueHelp: 'VAR=VALUE')
;

const _version = "0.0.1";

void printVersion([String version = _version]) {
  print("waigen-setup v$version");
}

void printUsage(ArgParser argParser) {
  print('Usage: waigen-setup <flags> [arguments]');
  print(argParser.usage);
}

void handle(ArgResults results, ArgParser parser) async {
  // Prereq
  var watch = Stopwatch();
  void _println(Object msg) => print("${watch.elapsed}: $msg");
  void _print(Object msg) => stdout.write("${watch.elapsed}: $msg");

  // Handle Args

  final manager = ProcessManager();
  // Start
  watch.start();

  // Check if necessary tools are present on system
  _println("Checking if necessary tools are present on system");
  {
    List<String> args = [];
    if (!results['cmake']) args.add('--top-level');
    if (results.wasParsed('verbose')) args.add('--verbose');
    if (Platform.isWindows) args.add('--win');
    final res = await manager.spawnDetached('dart', ['scripts/check.dart'] + args);
    res.stdout.transform(utf8.decoder).listen(stdout.write);
    res.stderr.transform(utf8.decoder).listen(stderr.write);
    if (await res.exitCode != 0) {
      kill(_println, watch, success: false);
      return;
    }
  }
  
  
  if (results.wasParsed('check')) {
    kill(_println, watch);
    return;
  }
  
  // Fetch WABT
  _println(
    "Fetching WABT",
  );
  {
    List<String> args = [];
    args.add(p.join(results['output'], 'wabt'));
    if (results.wasParsed('verbose')) args.add('--verbose');
    final res = await manager.spawnDetached('dart', ['scripts/fetch-wabt.dart'] + args);
    res.stdout.transform(utf8.decoder).listen(stdout.write);
    res.stderr.transform(utf8.decoder).listen(stderr.write);
    if (await res.exitCode != 0) {
      kill(_println, watch, success: false);
      return;
    }
  }
  // Build WABT
  _println(
    "Building WABT",
  );
  {
    List<String> args = [];
    args.add(p.join(results['output'], 'wabt'));
    if (!results['cmake']) args.add('--top-level');
    if (results.wasParsed('verbose')) args.add('--verbose');
    if (Platform.isWindows) args.add('--win');
    args.addAll(results['cmake-flags']);
    final res = await manager.spawnDetached('dart', ['scripts/build-wabt.dart'] + args);
    res.stdout.transform(utf8.decoder).listen(stdout.write);
    res.stderr.transform(utf8.decoder).listen(stderr.write);
    if (await res.exitCode != 0) {
      kill(_println, watch, success: false);
      return;
    }
  }

  // End
  kill(_println, watch);
}

void kill(void Function(Object) write, Stopwatch watch, {bool success = true}) {
  write("Complete");
  watch.stop();
  exit(success ? 0 : 1);
}

