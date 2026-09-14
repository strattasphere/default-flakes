{
  description = "Dotnet development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      mkDevShell = system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          dotnetPkg = pkgs.dotnetCorePackages.sdk_7_0;
        in
        pkgs.mkShell {
          buildInputs = [
            pkgs.zlib
            pkgs.openssl
            dotnetPkg
          ];

          NIX_LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            pkgs.stdenv.cc.cc
            pkgs.zlib
            pkgs.openssl
          ];

          NIX_LD = "${pkgs.stdenv.cc.libc}/bin/ld.so";

          shellHook = ''
            export DOTNET_ROOT="${dotnetPkg}"
            echo "✅ Dotnet SDK ${dotnetPkg.version} ready"
            echo "ℹ️  Ensure nix-ld is enabled on your system"
          '';
        };
    in
    {
      devShells = forAllSystems (system: {
        default = mkDevShell system;
      });
    };
}
