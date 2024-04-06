import 'dart:js_interop';

import 'wai_base.dart';
import '../helpers/fetch.dart';
import 'objects/wasm.dart';

export 'wai_base.dart';
export 'objects/wasm.dart';
export 'objects/global.dart';
export 'objects/table.dart';
export 'objects/memory.dart';

/// A more convenient for instantiating a WASM File
///
/// Returns a [WebAssemblyResult] which contains a [WebAssemblyResult.instance] and a [WebAssemblyResult.module]
Future<WebAssemblyResult> instantiateWasm(String file, [Object? imports]) {
  return WebAssembly.instantiateStreaming(
      fetch(file), imports.jsify() as JSObject);
}
