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

    variables = {
      # Needed for some extensions to function correctly
      GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";

      # See https://gitlab.gnome.org/GNOME/mutter/-/issues/2969
      __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa_drivers.outPath}/share/glvnd/egl_vendor.d/50_mesa.json";
      __GLX_VENDOR_LIBRARY_NAME = "mesa";
      VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    };

  };

  programs.dconf.enable = true;
}
