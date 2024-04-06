import 'dart:js_interop';

@JS('WebAssembly.Table')
extension type WebAssemblyTable._(JSObject _) implements JSObject {
  external WebAssemblyTable(WASMTableDescriptor tableDescriptor, [JSObject? value]);

  factory WebAssemblyTable.instantiate({required String element, required int initial, int? maximum, JSObject? value})
    => WebAssemblyTable(WebAssemblyTableDescriptor(element: element, initial: initial, maximum: maximum), value);

  external JSObject get(int index);

  external int grow(int delta, [JSObject value]);

  external void set(int index, JSObject value);

  external int get length;
}

typedef WASMTableDescriptor = WebAssemblyTableDescriptor;

extension type WebAssemblyTableDescriptor._(JSObject _) implements JSObject {
  external WebAssemblyTableDescriptor({String element, int initial, int? maximum});
  external String get element;
  external int get initial;
  external int? get maximum;
}