{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  environment.systemPackages = [
    (pkgs.rust-bin.stable.latest.minimal.override {
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
}
