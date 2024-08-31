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
    gnome.excludePackages = with pkgs; [
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      evince # document viewer
      totem # video player
      # gnome-photos
      gnome-tour
      # gnome-console
      gedit # text editor
      yelp # Help view
      gnome-music
      # gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-initial-setup
    ];

    systemPackages = with pkgs; [
      nautilus-open-any-terminal
      ## Apps
      pomodoro
      ## System
      gnome-tweaks
      dconf-editor
      ## Extensions
      gnome-extension-manager
      ## Monitoring deps
      clutter-gtk
      clutter
      libgtop
      cogl
      wirelesstools # improves performance
    ];

    variables = {
      # Needed for some extensions to function correctly
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";

      # gnome-shell randomly crashes without this
      # https://gitlab.gnome.org/GNOME/mutter/-/issues/3358
      MUTTER_DEBUG_KMS_THREAD_TYPE = "user";
    };

  };

  programs.dconf.enable = true;

  # GNOME dynamic triple buffering (huge performance improvement)
  # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
  nixpkgs.overlays = [
    (_: prev: {
      gnome = prev.gnome.overrideScope (
        _: gnomePrev: {
          mutter = gnomePrev.mutter.overrideAttrs (_: {
            src = pkgs.fetchFromGitLab {
              domain = "gitlab.gnome.org";
              owner = "vanvugt";
              repo = "mutter";
              rev = "triple-buffering-v4-46";
              hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
            };
          });
        }
      );
    })
  ];
}
