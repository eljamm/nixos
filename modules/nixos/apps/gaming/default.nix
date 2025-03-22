{
  pkgs,
  pkgsCustom,
  pkgsUnstable,
  ...
}:
{
  imports = [ ./controllers.nix ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Steam Remote Play
    dedicatedServer.openFirewall = false; # Source Dedicated Server
  };

  programs.gamescope = {
    enable = true;
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

  users.users.kuroko.extraGroups = [ "gamemode" ];
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

      # Games
      mgba
      minetestclient
      osu-lazer-bin
      vbam
      pkgsUnstable.unciv
    ])
    ++ (with pkgsCustom; [
      yuzu-ea
    ])
    ++ (with pkgsUnstable; [
      umu-launcher
      ryujinx-greemdev
    ]);
}
