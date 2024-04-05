import 'dart:js_interop';

import 'wai_base.dart';
import '../helpers/fetch.dart';

JSPromise instantiateWasm(String file, [Object? imports]) {
  return WebAssembly.instantiate(fetch(file), imports.jsify() as JSObject);
}