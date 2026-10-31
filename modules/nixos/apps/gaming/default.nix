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

  custom.systemPackages = with pkgs; {
    gaming = {
      utils = [
        (mkLazyApp cubiomes-viewer)
        (mkLazyApp ferium)
        goverlay
        (mkLazyApp igir)
        libstrangle
        mangohud
        (mkLazyApp np2kai) # pc98 emulator
        (mkLazyApp pince)
        pkgsUnstable.umu-launcher
        wineWow64Packages.staging
        winetricks
      ];

      launchers = [
        (mkLazyApp bottles)
        lutris
        pkgsUnstable.heroic
        (mkLazyApp prismlauncher)
        (mkLazyApp pkgsUnstable.ryubing)
      ];

      games = [
        (mkLazyApp mgba)
        openmw
        osu-lazer-bin
        (mkLazyApp pkgsUnstable.luanti-client)
        (mkLazyApp pkgsUnstable.unciv)
        vbam
        (mkLazyApp pkgsUnstable.odamex)
      ];
    };
  };
}
