import 'dart:convert';
import 'dart:js_interop';

import 'helpers/json.dart';

extension DartJSObject on Map {
  JSObject get toJS => parse(json.encode(this));
}
