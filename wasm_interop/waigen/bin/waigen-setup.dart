// ignore_for_file: file_names

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

void handle(ArgResults results, ArgParser parser) {
  // Prereq
  var watch = Stopwatch();
  void _print(Object msg) => print("${watch.elapsed}: $msg");

  // Handle Args

  final manager = ProcessManager();
  // Start
  watch.start();

  // Check if necessary tools are present on system
  _print("Checking if necessary tools are present on system");
  
  if (results.wasParsed('check')) {
    kill(_print, watch);
    return;
  }
  
  // Fetch WABT
  _print(
    "Fetching WABT",
  );
  // Build WABT
  _print(
    "Building WABT",
  );

  // End
  kill(_print, watch);
}

void kill(void Function(Object) write, Stopwatch watch) {
  write("Complete");
  watch.stop();
}

