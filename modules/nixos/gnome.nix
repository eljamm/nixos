{ pkgs, lib, ... }:

{
  services = {
    xserver = {
      enable = lib.mkDefault true;
      displayManager.gdm.enable = lib.mkDefault true;
      desktopManager.gnome.enable = lib.mkDefault true;
    };
    gnome.tracker-miners.enable = lib.mkDefault true;
    gnome.tracker.enable = lib.mkDefault true;

    # For enabling systray icons
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };

  environment = {
    gnome.excludePackages =
      (with pkgs; [
        # gnome-photos
        gnome-tour
        # gnome-console
        gedit # text editor
      ])
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-music
        epiphany # web browser
        geary # email reader
        evince # document viewer
        # gnome-characters
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
        yelp # Help view
        gnome-initial-setup
      ]);

    systemPackages = with pkgs; [
      nautilus-open-any-terminal
      ## System
      gnome.gnome-tweaks
      gnome.dconf-editor
      ## Extensions
      gnome-extension-manager
      ## Monitoring deps
      clutter-gtk
      clutter
      libgtop
      cogl
    ];

    # Needed for some extensions to function correctly
    variables.GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

  programs.dconf.enable = true;
}
