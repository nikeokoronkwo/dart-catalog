import 'dart:js_interop';

/// A Base `WebAssembly.Memory` Object
///
/// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/Memory/Memory
@JS('WebAssembly.Memory')
extension type WebAssemblyMemory._(JSObject _) implements JSObject {
  external WebAssemblyMemory(WASMMemDescriptor memoryDescriptor);

  factory WebAssemblyMemory.instantiate(
          {required int initial, int? maximum, bool? shared}) =>
      WebAssemblyMemory(WebAssemblyMemoryDescriptor(
          initial: initial, maximum: maximum, shared: shared));

  external JSObject get buffer;

  external JSObject grow(int delta);
}

typedef WASMMemDescriptor = WebAssemblyMemoryDescriptor;

/// An anonymous object used to encapsulate the `memoryDescriptor` for [WebAssemblyMemory] objects
extension type WebAssemblyMemoryDescriptor._(JSObject _) implements JSObject {
  external WebAssemblyMemoryDescriptor(
      {int initial, int? maximum, bool? shared});
  external int get initial;
  external int? get maximum;
  external bool? get shared;
}
