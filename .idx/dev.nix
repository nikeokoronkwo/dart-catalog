{pkgs, ...}: {
    channel = "stable-23.11";
    packages = [
        /* Core Packages for fetching Dart*/
        pkgs.apt
        pkgs.unzip

        /* Packages for waigen */
        pkgs.cmake
        pkgs.gcc

        /* Neovim because why not */
        pkgs.neovim

        /* Deno for JS Development/Interop */
        pkgs.deno

        /* WASM */
        pkgs.go
        pkgs.emscripten
        
    ];

    env = {};
    idx.extensions = [
        "dart-code.dart-code"
    ];
    # Enable previews and customize configuration
    idx.previews = {
        enable = true;
        previews = [];
    };
}