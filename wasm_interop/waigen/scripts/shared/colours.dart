import 'package:io/ansi.dart';
import 'package:logging/logging.dart';

final info = blue;
final warn = yellow;
final error = red;
final success = green;
final fatal = red;

AnsiCode levelColour(Level level) {
  return switch (level) {
    Level.INFO => info,
    Level.WARNING => warn,
    Level.SEVERE => error,
    Level.FINE => success,
    Level.FINER => fatal,
    Level.FINEST => fatal,
    Level.OFF => fatal,
    Level() => throw UnimplementedError(),
  };
}