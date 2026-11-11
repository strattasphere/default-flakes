{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [ rust-overlay.overlays.default ];
          };
          # Change the toolchain here: e.g. "rust-bin.stable.latest.default",
          # "rust-bin.beta.latest.default", or a pinned version like:
          # rust-bin.stable."1.80.0".default
          rustToolchain = pkgs.rust-bin.stable.latest.default.override {
            extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
            targets = [ ]; # e.g. [ "wasm32-unknown-unknown" ]
          };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              rustToolchain
              # Useful Rust-related tools
              cargo-watch
              cargo-expand
              cargo-audit
              # Common native dependencies for crates
              pkg-config
              openssl
              just
            ];

            env = {
              # Helps some crates find OpenSSL
              PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
              # Faster incremental builds
              CARGO_TERM_COLOR = "always";
            };

            shellHook = ''
              echo "🦀 Rust dev shell (rustc $(rustc --version))"
            '';
          };
        });
    };
}
