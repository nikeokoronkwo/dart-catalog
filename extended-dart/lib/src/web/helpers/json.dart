import 'dart:js_interop';

@JS('JSON.stringify')
external String stringify(dynamic value);

@JS('JSON.parse')
external JSObject parse(String text);