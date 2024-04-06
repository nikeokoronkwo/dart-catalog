import 'dart:js_interop';

extension type ArrayBuffer._(JSObject _) implements JSObject {
  external ArrayBuffer(int length, [JSObject? options]);

  external static isView(JSObject value);
}
