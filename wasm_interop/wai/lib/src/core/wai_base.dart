// ignore_for_file: non_constant_identifier_names

import 'dart:js_interop';
import 'objects/wasm.dart';

/// A WebAssembly Class Object
extension type WebAssembly._(JSObject _) {
  @JS('instantiateStreaming')
  external static JSPromise<WebAssemblyResult> _instantiateStreaming(
      JSPromise wasmStream, [JSObject? importObject]);
  
  @JS('compileStreaming')
  external static JSPromise<WebAssemblyModule> _compileStreaming(JSPromise wasmStream);

  @JS('instantiate')
  external static JSPromise<WebAssemblyResult> _instantiateBuffer(JSObject wasmBuffer, [JSObject? importObject]);

  @JS('instantiate')
  external static JSPromise<WebAssemblyInstance> _instantiateModule(WebAssemblyModule wasmModule, [JSObject? importObject]);

  @JS('compile')
  external static JSPromise<WebAssemblyModule> _compile(JSObject wasmBuffer);

  @JS('validate')
  external static JSBoolean _validate(JSObject wasmBuffer);

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
  static Future<WebAssemblyResult> instantiateStreaming(
      JSPromise wasmStream, [JSObject? importObject]) {
          if (importObject == null) {
            return _instantiateStreaming(wasmStream).toDart;
          } else {
            return _instantiateStreaming(wasmStream, importObject).toDart;
          }
        }

  /// Function used to instantiate a WebAssembly Module and Instance given an `ArrayBuffer`
  static Future<WebAssemblyResult> instantiateBuffer(JSObject wasmBuffer, [JSObject? importObject]) {
    if (importObject == null) {
      return _instantiateBuffer(wasmBuffer).toDart;
    } else {
      return _instantiateBuffer(wasmBuffer, importObject).toDart;
    }
  }

  /// Function used to instantiate a WebAssembly instance given an already compiled [WebAssemblyModule]
  static Future<WebAssemblyInstance> instantiateModule(WebAssemblyModule wasmModule, [JSObject? importObject]) {
    if (importObject == null) {
      return _instantiateModule(wasmModule).toDart;
    } else {
      return _instantiateModule(wasmModule, importObject).toDart;
    }
  }

  /// Used to instantiate a compiled WebAssembly Module
  /// 
  /// The [wasmObj] parameter can take an `ArrayBuffer` or a `WebAssemblyModule`. 
  /// 
  /// The function returns a Future completing with a [JSObject] 
  /// which can be a [WebAssemblyResult] if an `ArrayBuffer` was passed, or a [WebAssemblyInstance] if a [WebAssemblyModule] is passed.
  /// Therefore it is important you perform casting after getting the result to ensure you are able to use the desired result types,
  /// (since [union types do not exist in dart](https://github.com/dart-lang/language/issues/3608)).
  /// 
  /// ```dart
  /// WebAssembly.compileStreaming(fetch('wasm/main.wasm')).then((value) async {
  ///   return await WebAssembly.instantiate(value);
  /// }).then((instance) {
  ///   print((instance as WebAssemblyInstance).exports['sumofsquares'](9));
  /// });
  /// ```
  /// 
  /// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/instantiate_static
  static Future<JSObject> instantiate(
      JSObject wasmObj, [JSObject? importObject]) {
        if (wasmObj is WebAssemblyModule) {
          return instantiateModule(wasmObj, importObject);
        } else {
          return instantiateBuffer(wasmObj, importObject);
        }
      }
  
  
  
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
  static Future<WebAssemblyModule> compileStreaming(JSPromise wasmStream) => _compileStreaming(wasmStream).toDart;

  /// Used to compile WebAssembly before instantiating it
  /// 
  /// This produces a `WebAssemblyModule` which can later be instantiated and used later in code
  /// 
  /// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/compile_static
  static Future<WebAssemblyModule> compile(JSObject wasmBuffer) => _compile(wasmBuffer).toDart;

  /// Validates whether an `ArrayBuffer` is a valid WASM Binary Code.
  /// 
  /// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/validate_static
  static bool validate(JSObject wasmBuffer) => _validate(wasmBuffer).toDart;

  @JS('Memory')
  external static JSObject Memory(JSObject memoryDescriptor);

  @JS('Table')
  external static JSObject Table(JSObject tableDescriptor, [JSAny? value]);

  @JS('Global')
  external static JSObject Global(JSObject descriptor, JSAny value);
}