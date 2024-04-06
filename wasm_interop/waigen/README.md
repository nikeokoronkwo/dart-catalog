# waigen - Generate Bindings for WASM Interop and Usage in Dart

## Installing this Tool
Waigen depends on some of the tools included in 

To use this tool, add the tool as a dev dependency to your project.
```yaml
```

Then run the tool on your webassembly file:
```bash
dart run waigen main.wasm
```

If run like this, the generated code will be written to `main.wasm.dart` with default configurations. However, it is recommended you create a `wasm-config.yaml` file to customize the generated code.

```bash
# Reads the wasm-config.yaml file in current directory and writes to file.dart
dart run waigen main.wasm -o file.dart 

# Reads the wasm-config.yaml file provided to --config option and writes to file provided in config
dart run waigen --config config.yaml main.wasm 
```

For more information on the tool and options, check the help.
```bash
dart run waigen --help
```

## Using this Tool
In order to use this tool to interop with other languages that compile to WASM, or WASM itself, ensure that you compile without any glue code or unnecessary overheads, as the `waigen` tool is designed so that the user, with Dart, can handle any glue code or just focus on the desired functions. 
Check the [docs](./docs/) for any additional information concerning how to work with various languages to meet the given criteria.

This tool can perform various functions such as generating Dart Objects and Bindings for WASM Interop, as well as `dart2wasm` imports and exports for WASM Interop on the VM.

### Web Bindings
If you are using this tool on the web, you will need to indicate so by passing the `--web` flag. 
This analyzes the WASM file generated and produces an object with function definitions to represent the object exported as the `WebAssembly.Instance().exports` object. If you don't do this, `wai` would assume the exports as a `Map`. The tool also analyzes the imports needed by the WASM File and provides them 

### `dart2wasm` Bindings
If you are not using the tool on the we

### C Interop with `ffigen`
Thanks to [wasm2c](https://github.com/WebAssembly/wabt), Waigen has the ability to interop with C code and compile WebAssembly to C source code. If you pass the `--target-c` (or `-c`) option to `waigen`, Waigen will convert the given WebAssembly to C source code, with generated header files. This can be useful if you plan on working with C code, as well as WASM code, in your project. However, if you plan to create bindings for the given C code as well, it is recommended you use this tool alongside [`ffigen`](https://pub.dev/packages/ffigen) to generate the bindings.

### With `jsigen`
In the case you do ultimately need to couple your given WebAssembly with some JavaScript, you can do so by pairing `waigen` with [`jsigen`](https://pub.dev/packages/jsigen). `waigen` will produce the WebAssembly bindings, while `jsigen` will port the given functions and generated glue code from the JavaScript file to Dart.

Add `jsigen` as a dev dependency to your project.
```yaml
dev_dependencies:
    waigen: <latest>
    jsigen: <latest>
```

Then run the following command with the given WebAssembly File and JavaScript File
```bash
dart run waigen --jsigen --glue <JavaScript File> <WebAssembly File> 
```

This can be very useful if you plan on using [`dart2wasm`](). 

However, note that this feature (as well as `jsigen`) is experimental, and only works on Dart Web.

## Building this Tool
In order to build this tool, you will need the [WebAssembly Binary Toolkit (WABT)](https://github.com/WebAssembly/wabt), as well as the [dart SDK]() (obviously).
