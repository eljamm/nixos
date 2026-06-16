{
  pkgs,
  pkgsCustom,
  pkgsUnstable,
  ...
}:
{
  imports = [
    ./controllers.nix
  ];

  boot.kernelModules = [ "ntsync" ];

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
      mangohud
      np2kai # pc98 emulator
      pince
      wineWow64Packages.staging
      winetricks

      # Launchers
      bottles
      pkgsUnstable.heroic
      lutris
      prismlauncher

      # Games
      mgba
      pkgsUnstable.luanti-client
      osu-lazer-bin
      vbam
      pkgsUnstable.unciv
    ])
    ++ (with pkgsCustom; [
      # yuzu-ea
    ])
    ++ (with pkgsUnstable; [
      umu-launcher
      ryubing
      odamex
    ]);
}
