{ inputs, ... }:

{
  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  programs = {
    nix-index-database.comma.enable = true;
    command-not-found.enable = true;
    nix-index = {
      enable = true;
      enableBashIntegration = false;
      enableZshIntegration = false;
    };
  };
}
