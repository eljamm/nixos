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
                  hash = "sha256-JaqJvbuIAFDKJ3y/8j/7hZ+/Eqru+Mm1d3EvjfmCcug=";
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

                patches = (oldAttrs.patches or [ ]) ++ [
                  # Prefer GPUs with built-in panels connected when selecting a primary GPU
                  # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/4114
                  (pkgs.fetchpatch2 {
                    url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/4114.patch";
                    hash = "sha256-MLWUKQGuhgIkgAKrVUJAc4fgPvHUaYlS79UVsTWF/TE=";
                  })
                  # Avoid crashed by defaulting to high priority thread instead
                  # of realtime for the KMS thread
                  # https://www.phoronix.com/news/GNOME-High-Priority-KMS-Thread
                  # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/4124
                  (pkgs.fetchpatch2 {
                    url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/4124.patch";
                    hash = "sha256-h1gjyZx23NQ3VDwcGRy6hLkfgLdukao7NzH+48C/NE4=";
                  })
                ];
              });
            })
          ];
        };
      };
  };
}
