{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [ ];

  # https://discourse.nixos.org/t/get-to-the-login-screen-faster-on-nixos/57481
  systemd.targets.network-online.wantedBy = lib.mkForce [ ];
}
