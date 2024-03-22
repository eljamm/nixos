{ pkgs, ... }:

{
  config = {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = (with pkgs; [
      # gnome-photos
      gnome-tour
      # gnome-console
      gedit # text editor
    ]) ++ (with pkgs.gnome; [
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
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      nautilus-open-any-terminal
      ## System
      gnome.gnome-tweaks
      gnome.dconf-editor
      ## Extensions
      # gnomeExtensions.appindicator
    ];
    # For enabling systray icons
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };
}
