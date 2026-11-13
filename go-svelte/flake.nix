{
  description = "Go development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      # lib is available directly off the nixpkgs flake output
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
               go
              gotools
              gopls
              just
              starship

              # wails3 build deps
              pkg-config
              stdenv.cc               # or just 'gcc'
              # runtime/build libs the CLI tool itself links against:
              gtk4
              webkitgtk_6_0
              # node 
              nodejs_26
              yarn
              svelte-language-server
            ];

            # Workaround for https://github.com/NixOS/nix/issues/5873:
            # a spawned subshell gives a broken prompt. Setting SHELL fixes it.
            shellHook = ''
              export GOPATH="''${GOPATH:-$HOME/go}"
              export GOBIN="''${GOBIN:-$GOPATH/bin}"
              export PATH="$GOBIN:$PATH"
              export SHELL=${pkgs.lib.getExe pkgs.bash}
              export STARSHIP_CONFIG="$PWD/starship.toml"
              eval "$(starship init bash)"
            '';
          };
        });
    };
}
