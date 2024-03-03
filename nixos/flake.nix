{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... } @inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            self.nixosModules.gnome
            self.nixosModules.test
            # inputs.home-manager.nixosModules.default
            # ./modules/nixos/test.nix
          ];
        };
      };

      nixosModules = {
        test = ./modules/nixos/test.nix;
        gnome = { pkgs, ... }: {
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
              gnome.gnome-tweaks
              gnome.dconf-editor
            ];
          };
        };
      };

    };
}
