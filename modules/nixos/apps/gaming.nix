{ pkgs, ... }:

{
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
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
