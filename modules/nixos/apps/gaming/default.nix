{ inputs, pkgs, ... }:

let
  inherit (inputs.umu.packages.${pkgs.system}) umu;
in

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Steam Remote Play
    dedicatedServer.openFirewall = false; # Source Dedicated Server
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  programs.gamescope.enable = true;

  users.users.kuroko.packages =
    (with pkgs; [
      # Utils
      cubiomes-viewer
      ferium
      goverlay
      igir
      libstrangle
      wineWowPackages.staging
      winetricks

      # Launchers
      bottles
      heroic
      lutris
      prismlauncher
      ryujinx

      # Games
      mgba
      minetestclient
      osu-lazer-bin
      vbam
    ])
    ++ [ umu ];

  nixpkgs.overlays = [
    (final: prev: {
      gamescope = prev.gamescope.overrideAttrs (
        finalAttrs: oldAttrs: {
          version = "3.14.29";
          src = final.fetchFromGitHub {
            owner = "ValveSoftware";
            repo = "gamescope";
            rev = "refs/tags/${finalAttrs.version}";
            fetchSubmodules = true;
            hash = "sha256-q3HEbFqUeNczKYUlou+quxawCTjpM5JNLrML84tZVYE=";
          };
        }
      );
    })
  ];
}
