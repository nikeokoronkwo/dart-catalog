// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:io/io.dart';

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


final parser = ArgParser()
  ..addFlag('help', abbr: 'h', help: 'Show this help message', negatable: false)
  ..addFlag('version', abbr: 'V', help: 'Show version', negatable: false)
  ..addFlag('verbose', abbr: 'v', help: 'Produce verbose logging', negatable: false)
  ..addFlag('only-required', help: 'Save only required tools', negatable: false)
  ..addFlag('cmake', help: 'Whether to use cmake for building the project', defaultsTo: true, negatable: true)
  ..addOption('output', abbr: 'o', defaultsTo: '.', help: 'Output directory')
  ..addFlag('check', abbr: 'c', help: 'Check if necessary tools are present on system', negatable: false)
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
  List<String> args = [];
  if (!results['cmake']) args.add('--top-level');
  if (results.wasParsed('verbose')) args.add('--verbose');
  if (Platform.isWindows) args.add('--win');
  final res = await manager.spawn('dart', ['run', 'scripts/check.dart'], runInShell: true);
  
  
  if (results.wasParsed('check')) {
    kill(_println, watch);
    return;
  }
  
  // Fetch WABT
  _println(
    "Fetching WABT",
  );
  // Build WABT
  _println(
    "Building WABT",
  );

  // End
  kill(_println, watch);
}

void kill(void Function(Object) write, Stopwatch watch, {bool success = true}) {
  write("Complete");
  watch.stop();
  exit(success ? 0 : 1);
}

