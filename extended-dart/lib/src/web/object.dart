import 'dart:convert';
import 'dart:js_interop';

import 'helpers/json.dart';

extension DartMap on JSObject {
  Map get toDartMap => json.decode(stringify(this));
}
