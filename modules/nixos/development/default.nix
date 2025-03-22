{ inputs, ... }:
{
  imports = [
    ./containers.nix
  ];

  flake.nixosModules = {
    dev-rust =
      { pkgs, lib, ... }:
      {
        nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

        environment.systemPackages = [
          (pkgs.rust-bin.stable.latest.default.override {
            extensions = [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-analyzer"
            ];
          })
          pkgs.cargo-auditable
        ];
      };
  };
}
