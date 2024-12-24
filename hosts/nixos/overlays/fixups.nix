{ pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    # Make kitty not freeze when using PaperWM with multi-monitors
    # https://github.com/kovidgoyal/kitty/issues/3069
    (final: prev: {
      kitty = prev.kitty.overrideAttrs (oldAttrs: {
        patches = (oldAttrs.patches or [ ]) ++ [
          ./patches/kitty/0002-revert-Wayland-suspend.patch
        ];
      });
    })
  ];

  # https://discourse.nixos.org/t/get-to-the-login-screen-faster-on-nixos/57481
  systemd.targets.network-online.wantedBy = lib.mkForce [ ];
}
