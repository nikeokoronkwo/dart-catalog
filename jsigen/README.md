# JSIGEN - Generate JavaScript Bindings for your Dart Code
Jsigen is a CLI tool to generate JavaScript bindings for your Dart code.
It parses, analyzes and generates the given Dart Objects for your JavaScript code using Dart's JavaScript interop guidelines

## Using this Tool
By default, `jsigen` uses the latest **extension type** interop strategy to create Dart Bindings. If you are using a much older codebase, or prefer not to use this, you can use the `--legacy` flag to use the legacy **class/static interop** interop strategy to create Dart Bindings.

## Usage
```bash
dart run jsigen <js file> -o <output>
```

You can pass config located in a `js-config.yaml` file to configure the bindings generated.
```bash
dart run jsigen <js file> --config <config file> # The config file option is optional, and defaults to the js-config.yaml file in the root directory
```

> **NOTE**: This project is experimental and nothing works for now.
> 
> Contributions and ideas are welcome