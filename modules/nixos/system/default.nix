{ pkgs, username, ... }:
{
  imports = [
    ./programs.nix
  ];

  # Set fish as the default user shell for all users
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;

  documentation.nixos.enable = false;
  documentation.man.generateCaches = false; # slow eval time with fish

  time.timeZone = "Africa/Tunis";

  # Internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "de";
      variant = "nodeadkeys";
    };
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  environment.sessionVariables = rec {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Not officially in the specification
    XDG_BIN_HOME = "$HOME/.local/bin";
    PATH = [ "${XDG_BIN_HOME}" ];

    # for `programs.nh`
    FLAKE = "/home/${username}/nixos";
  };

  # Output more information when building the system:
  # https://discourse.nixos.org/t/how-to-make-nixos-rebuild-output-more-informative/25549/11
  system.activationScripts.diff = # bash
    ''
      if [[ -e /run/current-system ]]; then
        echo
        ${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig" | grep -w "→" | grep -w "KiB" | column --table --separator " ,:" | ${pkgs.choose}/bin/choose :1 -4: | ${pkgs.gawk}/bin/awk '{s=$0; gsub(/\033\[[ -?]*[@-~]/,"",s); print s "\t" $0}' | sort -k5,5gr | ${pkgs.choose}/bin/choose 6: | column --table
        Sum=$(${pkgs.nix}/bin/nix store diff-closures /run/current-system "$systemConfig" | grep -w "→" | grep -w "KiB" | column --table --separator " ,:" | ${pkgs.choose}/bin/choose -2 | ${pkgs.ansifilter}/bin/ansifilter | tr "\n" " " | ${pkgs.gawk}/bin/awk 'NR == 1 { $0 = "0" $0 }; 1' | ${pkgs.bc}/bin/bc -l)
        if (( $(echo "$Sum != 0" | ${pkgs.bc}/bin/bc -l) )); then
        SumMiB=$(echo "scale=2; $Sum/1024" | ${pkgs.bc}/bin/bc -l)
        echo -en "\nSum: "
        if (( $(echo "$SumMiB > 0" | ${pkgs.bc}/bin/bc -l) )); then TERM=xterm-256color ${pkgs.ncurses}/bin/tput setaf 1; elif (( $(echo "$SumMiB < 0" | ${pkgs.bc}/bin/bc -l) )); then TERM=xterm-256color ${pkgs.ncurses}/bin/tput setaf 2; fi
        echo -e "$SumMiB MiB\n"
        TERM=xterm-256color ${pkgs.ncurses}/bin/tput setaf 7
        fi
      fi
    '';
}
