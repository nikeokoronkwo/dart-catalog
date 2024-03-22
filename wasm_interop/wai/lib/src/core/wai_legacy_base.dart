import 'dart:js';

import 'package:js/js.dart';
import 'dart:js_util';

@JS('WebAssembly')
@staticInterop
class WebAssembly {}

extension on WebAssembly {
  external static instantiateStreaming(Object wasm, Object importObject);
  external static instantiate(Object wasmBuffer, Object importObject);
}