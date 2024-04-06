# WAI - WebAssembly Interfaces
[![pub package](https://img.shields.io/pub/v/wai.svg)](https://pub.dev/packages/wai)
[![Pub Points](https://img.shields.io/pub/points/wai)](https://pub.dev/packages/wai)

The WAI Package is a web interface package for interoping and making use of WebAssembly directly in your web project. For making use of WAI server side or on the VM, check the `wai_vm` package.

## Using this Package
### Normal WebAssembly
You can use this package to work with WebAssembly normally via the `WebAssembly` object. This object either comes as a class, for those using `wai` on the legacy `dart:html` and `package:js` packages, and as an extension type for those using the package with `package:web` and `dart:js_interop`.

This package also comes with js implementations of helper interfaces you may need like `fetch` to get files rather than reading them via `dart:io` which isn't available on the web.
```dart
void main() {
    WebAssembly.instantiateStream(fetch('file.wasm')).then((module) {
        // Do Something
    });
    // OR
    instantiateWasm('file.wasm').then((module) {
        // Do Something
    });
}
```
### WASM Bindings with `waigen`
You can also generate WASM bindings between languages and work with them on Dart via the `wai` interfaces either by manually creating the bindings, or with the use of `waigen`. For more information on `waigen`, check out [the package](https://github.com/nikeokoronkwo/dart-catalog/tree/main/wasm_interop/waigen).


## Contributing
Contributions to this package are welcome! Please check the [contributing guidelines](https://github.com/nikeokoronkwo/dart-catalog/tree/main/wasm_interop/CONTRIBUTING.md) before making one.

## License
[BSD-3-Clause](./LICENSE)
