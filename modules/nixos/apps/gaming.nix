{ inputs, pkgs, ... }:

let
  inherit (inputs.umu.packages.${pkgs.system}) umu;
in

{
  programs = {
    steam = {
      enable = true;
      # Open ports in the firewall
      remotePlay.openFirewall = false; # Steam Remote Play
      dedicatedServer.openFirewall = false; # Source Dedicated Server
    };

    gamemode = {
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

    gamescope.enable = true;
  };

  users.users.kuroko.packages =
    (with pkgs; [
      # Utils
      cubiomes-viewer
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
    # Gamescope
    (_: prev: {
      gamescope = prev.gamescope.overrideAttrs (_: rec {
        version = "3.14.24";
        src = prev.fetchFromGitHub {
          owner = "ValveSoftware";
          repo = "gamescope";
          rev = "refs/tags/${version}";
          fetchSubmodules = true;
          hash = "sha256-+8uojnfx8V8BiYAeUsOaXTXrlcST83z6Eld7qv1oboE=";
        };
      });
    })
  ];
}
