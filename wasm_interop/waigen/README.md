# WAIGEN - Generate Bindings for WASM Interop and Usage in Dart
Waigen is an easy, powerful and feature-rich dart tool used for generating bindings for WASM code to your dart code, whether you're using it on the web (with [wai](https://pub.dev/packages/wai)), on the Dart VM (with [wai_vm](https://pub.dev/packages/wai_vm)), or even with the experimental `dart2wasm`.

## Getting Started

### Setup with `waigen-setup`
In order to use `waigen`, you will need to install the webassembly binary toolkit. In order to streamline this process, you can run the `waigen-setup` command to fetch and install WABT and other tools needed for `waigen` to work properly.

### Installing this Tool
Waigen depends on some of the tools included in 

To use this tool, add the tool as a dev dependency to your project.
```yaml
dev_dependencies:
    waigen: <latest>
```

You should also have either `wai` or `wai_vm` as a dependecy on your project, depending on where you are planning to use the generated bindings

Then run the tool on your webassembly file:
```bash
dart run waigen main.wasm
```

If run like this, the generated code will be written to `main.wasm.dart` with default configurations. However, it is recommended you create a `wasm-config.yaml` file to customize the generated code.

```bash
# Reads the wasm-config.yaml file in current directory and writes to file.dart
dart run waigen main.wasm -o file.dart 

# Uses the wasm-config.yaml file provided to --config option and writes to file provided in config
dart run waigen --config config.yaml
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
This analyzes the WASM file generated and produces an object with function definitions to represent the object exported as the `WebAssembly.Instance().exports` object. If you don't do this, `wai` would assume the exports as a `Map`. The tool also analyzes the imports needed by the WASM File and provides them as an object for easy usage with `wai`'s `WebAssembly` object and features.

```bash
dart run waigen --web 
```

### `dart2wasm` Bindings
If you are not using the tool on the web, you can make use of WebAssembly bindings on the Dart VM when compiling to WebAssembly by leveraging the [`dart2wasm`](https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm/README.md) tool, and it's related functionality. In order to do this, you will need to pass the `--dart2wasm` flag. Remember that dart2wasm is experimental.

```bash
dart run waigen --dart2wasm
```

### C Interop with `ffigen`
Thanks to [wasm2c](https://github.com/WebAssembly/wabt), Waigen has the ability to interop with C code and compile WebAssembly to C source code. If you pass the `--target-c` (or `-c`) option to `waigen`, Waigen will convert the given WebAssembly to C source code, with generated header files. This can be useful if you plan on working with C code, as well as WASM code, in your project. However, if you plan to create bindings for the given C code as well, it is recommended you use this tool alongside [`ffigen`](https://pub.dev/packages/ffigen) to generate the bindings.

### (Experimental) With `jsigen`
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

This can be very useful if you plan on using dart files compiled to wasm with [`dart2wasm`](https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm/README.md). 

However, note that this feature (as well as `jsigen`) is experimental, and only works on Dart Web.

### (Experimental) with `wai_vm`'s normal wasm support
> NOTE: This feature is experimental and depends on the [seagort package](https://pub.dev/packages/seagort).

## Building this Tool
In order to build this tool, you will need the [WebAssembly Binary Toolkit (WABT)](https://github.com/WebAssembly/wabt), as well as the [dart SDK](https://github.com/dart-lang/sdk) installed (obviously).
