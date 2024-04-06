import 'dart:js_interop';

/// A `WebAssembly.Global` Object
/// 
/// https://developer.mozilla.org/en-US/docs/WebAssembly/JavaScript_interface/Global
@JS('WebAssembly.Global')
extension type WebAssemblyGlobal._(JSObject _) implements JSObject {
  external WebAssemblyGlobal(WASMGlobDescriptor descriptor, JSAny value);
  factory WebAssemblyGlobal.instantiate(JSAny value, {required String descValue, required bool mutable}) 
    => WebAssemblyGlobal(WebAssemblyGlobalDescriptor(mutable: mutable, value: descValue), value);
  
  external JSAny get value;
  external set value(JSAny newValue);

  external JSAny valueOf();
}

typedef WASMGlobDescriptor = WebAssemblyGlobalDescriptor;

extension type WebAssemblyGlobalDescriptor._(JSObject _) implements JSObject {
  external WebAssemblyGlobalDescriptor({String value, bool mutable});
  external String get value;
  external bool get mutable;
}

