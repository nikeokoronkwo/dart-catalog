import 'colours.dart';
import 'package:logging/logging.dart';

void setUpLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${levelColour(record.level).wrap('[${record.level.name}]')}:${record.level.name != "CONFIG" ? "${record.time}:" : ""} ${record.message}');
  });
}