{ pkgs, inputs, ... }:

{
  nix = {
    package = pkgs.lix;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Storage Optimization
    optimise.automatic = true;

    settings = {
      # Cache
      substituters = [
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];

      warn-dirty = false; # NOTE: I do not care.

      # Limit build
      # TODO: set per machine
      max-jobs = 4;
      cores = 12;
    };

  };

  # https://wiki.nixos.org/wiki/Flakes#Getting_Instant_System_Flakes_Repl
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  environment.systemPackages =
    let
      repl_path = toString ../../.;
      fast-repl = pkgs.writeShellScriptBin "fast-repl" ''
        source /etc/set-environment
        nix repl --file "${repl_path}/repl.nix" "$@"
      '';
    in
    [ fast-repl ];
}
