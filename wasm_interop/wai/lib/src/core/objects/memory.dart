import 'dart:js_interop';

@JS('WebAssembly.Memory')
extension type WebAssemblyMemory._(JSObject _) {
  external WebAssemblyMemory(JSObject memoryDescriptor);
}
