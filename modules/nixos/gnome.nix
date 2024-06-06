{ pkgs, lib, ... }:

{
  services.xserver.enable = lib.mkDefault true;
  services.xserver.displayManager.gdm.enable = lib.mkDefault true;
  services.xserver.desktopManager.gnome.enable = lib.mkDefault true;
  services.gnome.tracker-miners.enable = lib.mkDefault true;
  services.gnome.tracker.enable = lib.mkDefault true;
  environment.gnome.excludePackages =
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
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    nautilus-open-any-terminal
    ## System
    gnome.gnome-tweaks
    gnome.dconf-editor
    ## Extensions
    gnome-extension-manager
  ];
  # For enabling systray icons
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
}
