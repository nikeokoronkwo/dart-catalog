import 'package:args/args.dart';

final parser = ArgParser()
  ..addFlag('help', abbr: 'h', help: "Show help")
  ..addFlag('verbose', abbr: 'V', help: "Show verbose logging")
  ..addFlag('version', abbr: 'v', help: "Show version")
  ..addOption('output', abbr: 'o', help: "Output file to write to")
  ..addOption('config', help: 'Path to the config file to use')
  ..addFlag('web', abbr: 'w', help: "Write configurations for the web")
  ..addFlag('dart2wasm', help: "Create bindings for building with dart2wasm")
  ..addFlag('--target-c', abbr: 'c', help: "Compile to C and use ffigen to create WASM Bindings")
  // ..addOption('jsigen', help: "Run code with jsigen and work with JavaScript Glue Code")
  ;

void main() {
  
}