{ inputs, ... }:
{
  flake.nixosModules = {
    desktops-gnome =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      let
        cfg = config.custom.desktops.gnome;
      in
      {
        options.custom.desktops.gnome = {
          enable = lib.mkEnableOption "the Gnome Desktop environment";
          enableGreeter = lib.mkEnableOption "the Gnome login manager";
        };

        config = {
          custom.desktops.gnome.enableGreeter = lib.mkDefault cfg.enable;

          services.xserver = {
            enable = lib.mkDefault cfg.enable;
            displayManager.gdm.enable = lib.mkDefault cfg.enableGreeter;
            desktopManager.gnome = {
              enable = lib.mkDefault cfg.enable;
              extraGSettingsOverridePackages = [ pkgs.mutter ];
            };
          };

          # Disable file indexing (high resource consumption and I don't need it)
          services.gnome.localsearch.enable = lib.mkForce false;
          services.gnome.tinysparql.enable = lib.mkForce false;

          # Needed for enabling systray icons
          services.udev.packages = lib.optionals cfg.enable [ pkgs.gnome-settings-daemon ];

          programs.dconf.enable = true;

          environment = {
            gnome.excludePackages = with pkgs; [
              atomix # puzzle game
              cheese # webcam tool
              epiphany # web browser
              evince # document viewer
              geary # email reader
              gedit # text editor
              gnome-initial-setup
              gnome-music
              gnome-system-monitor
              gnome-tour
              hitori # sudoku game
              iagno # go game
              loupe # image viewer
              tali # poker game
              totem # video player
              yelp # Help view
            ];

            systemPackages = with pkgs; [
              nautilus-open-any-terminal
              # Apps
              gnome-pomodoro
              # System
              dconf-editor
              gnome-tweaks
              # Extensions
              gnome-extension-manager
              # Monitoring deps
              clutter
              clutter-gtk
              cogl
              libgtop
              wirelesstools # improves performance
            ];

            variables = lib.mkIf cfg.enable {
              # Needed for some extensions to function correctly
              GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
            };
          };

          nixpkgs.overlays = [
            (final: prev: {
              mutter = prev.mutter.overrideAttrs (oldAttrs: {
                # GNOME dynamic triple buffering (huge performance improvement)
                # See https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1441
                src = final.fetchFromGitLab {
                  domain = "gitlab.gnome.org";
                  owner = "vanvugt";
                  repo = "mutter";
                  rev = "triple-buffering-v4-47";
                  hash = "sha256-1VXEzKwzrqLCZby2oWxjclA08kPhxs/Om5N17qYeglM=";
                };

                # Dynamic triple buffering dependency
                preConfigure =
                  let
                    gvdb = final.fetchFromGitLab {
                      domain = "gitlab.gnome.org";
                      owner = "GNOME";
                      repo = "gvdb";
                      rev = "2b42fc75f09dbe1cd1057580b5782b08f2dcb400";
                      hash = "sha256-CIdEwRbtxWCwgTb5HYHrixXi+G+qeE1APRaUeka3NWk=";
                    };
                  in
                  ''
                    cp -a "${gvdb}" ./subprojects/gvdb
                  '';

                # patches = (oldAttrs.patches or [ ]) ++ [
                #   # FIX: conflict with triple buffering
                #   # Improve frame rate on monitors attached to secondary GPUs in copy mode
                #   # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/4027
                #   # NOTE: expect hash mismatch as the MR is still open
                #   # (pkgs.fetchpatch2 {
                #   #   url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/4027.patch";
                #   #   hash = "sha256-2J+t/fa7wVDUHCE7OqOFFZrknctWQfobRTXkl92Hf1w=";
                #   # })
                # ];
              });
            })
          ];
        };
      };
  };
}
