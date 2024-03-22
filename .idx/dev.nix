{pkgs, ...}: {
    channel = "stable-23.11";
    packages = [
        pkgs.apt
        pkgs.deno
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

    idx.workspace.onCreate = {
        
    };
}