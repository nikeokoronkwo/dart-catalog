import 'package:js/js.dart';

@JS('WebAssembly')
@staticInterop
class WebAssembly {
  external static instantiateStreaming(Object wasm, Object importObject);
  external static instantiate(Object wasmBuffer, Object importObject);
}

extension WebAssemblyDeclarations on WebAssembly {

}
