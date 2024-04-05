// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';

/// A WebAssembly Class Object
extension type WebAssembly._(JSObject _) {
  /// The `WebAssembly.instantiateStreaming` function used to compile and instantiate a WebAssembly module directly from a streamed underlying source.
  /// 
  /// This is more convenient than using `instantiate` as it can turn the byte code directly into Module/Instance instances,
  /// cutting out the need to separately put the Response into an ArrayBuffer.
  /// 
  /// ```dart
  /// WebAssembly.instantiateStreaming(fetch("simple.wasm"), importObject).then(
  ///   (obj) => obj.instance.exports.exported_func()
  /// );
  /// ```
  /// 
  /// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/instantiateStreaming_static
  external static JSPromise instantiateStreaming(
      JSPromise wasmStream, [JSObject? importObject]);

  /// Used to instantiate a compiled WebAssembly Module
  /// 
  /// The [wasmBuffer] parameter can take an `ArrayBuffer` or a `WebAssemblyModule`.
  /// 
  /// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/instantiate_static
  /// 
  /// TODO: Create separate functions `instantiateBuffer` and `instantiateModule`
  external static JSPromise instantiate(
      JSObject wasmBuffer, [JSObject? importObject]);
  
  /// Used to compile a WebAssembly Module without streaming
  /// 
  /// This also eliminates the need of having to put the response in an ArrayBuffer.
  /// 
  /// ```dart
  /// WebAssembly.compileStreaming(fetch("simple.wasm")).then(
  ///   (module) => WebAssembly.instantiate(module, importObject),
  /// ).then(
  ///   (instance) => instance.exports.exported_func(),
  /// );
  /// ```
  /// 
  /// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/compileStreaming_static
  external static JSPromise compileStreaming(JSPromise wasmStream);

  /// Used to compile WebAssembly before instantiating it
  /// 
  /// This produces a `WebAssemblyModule` which can later be instantiated and used
  external static JSPromise compile(JSObject wasmBuffer);

  @JS('Memory')
  external static JSObject Memory(JSObject memoryDescriptor);

  @JS('Table')
  external static JSObject Table(JSObject tableDescriptor, [JSAny? value]);

  @JS('Global')
  external static JSObject Global(JSObject descriptor, JSAny value);
}