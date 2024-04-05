import 'package:js/js.dart';

@JS('WebAssembly')
@staticInterop
class WebAssembly {}

extension WebAssemblyDeclarations on WebAssembly {
  external static instantiateStreaming(Object wasm, Object importObject);
  external static instantiate(Object wasmBuffer, Object importObject);
}
