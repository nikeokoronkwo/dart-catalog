import 'dart:js_interop';

extension type WebAssembly._(JSObject _) {
  external static JSPromise instantiateStreaming(JSPromise wasm, JSObject importObject);
  external static JSPromise instantiate(JSObject wasmBuffer, JSObject importObject);
}