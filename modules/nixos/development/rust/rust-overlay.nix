{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];
  environment.systemPackages = [
    (lib.hiPrio pkgs.rust-bin.nightly.latest.rust-analyzer)
    (pkgs.rust-bin.stable.latest.default.override {
      extensions = [
        "cargo"
        "clippy"
        "rust-src"
        "rustc"
        "rustfmt"
      ];
    })
  ];
}
