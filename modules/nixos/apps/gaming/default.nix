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
        cubiomes-viewer
        ferium
        goverlay
        igir
        libstrangle
        mangohud
        np2kai # pc98 emulator
        pince
        pkgsUnstable.umu-launcher
        wineWow64Packages.staging
        winetricks
      ];

      launchers = [
        bottles
        lutris
        pkgsUnstable.heroic
        (pkgs.mkLazyApp prismlauncher)
        (pkgs.mkLazyApp pkgsUnstable.ryubing)
      ];

      games = [
        mgba
        openmw
        osu-lazer-bin
        pkgsUnstable.luanti-client
        (pkgs.mkLazyApp pkgsUnstable.unciv)
        vbam
        (pkgs.mkLazyApp pkgsUnstable.odamex)
      ];
    };
  };
}
