import 'dart:js_interop';

extension type WebAssemblyResult._(JSObject _) implements JSObject {
  external WebAssemblyResult({JSObject instance, JSObject module});
  external WebAssemblyModule get module;
  external WebAssemblyInstance get instance;
}

@JS('WebAssembly.Instance')
extension type WebAssemblyInstance._(JSObject _) implements JSObject {
  external WebAssemblyInstance(WebAssemblyModule module, [JSObject? importObject]);
}

@JS('WebAssembly.Module')
extension type WebAssemblyModule._(JSObject _) implements JSObject {
  external WebAssemblyModule(JSObject bufferSource);
}