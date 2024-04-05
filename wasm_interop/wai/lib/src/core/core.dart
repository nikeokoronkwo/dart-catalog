import 'dart:js_interop';

import 'wai_base.dart';
import '../helpers/fetch.dart';

export 'wai_base.dart';

JSPromise instantiateWasm(String file, [Object? imports]) {
  return WebAssembly.instantiateStreaming(fetch(file), imports.jsify() as JSObject);
}