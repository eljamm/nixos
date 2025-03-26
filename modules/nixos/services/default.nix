{ ... }:
{
  flake.nixosModules = {
    services-main =
      { ... }:
      {
        imports = [
          ./anki.nix
          # ./blocky.nix # TODO: conflicts with lxc's dnsmasq
          ./keyd.nix
          ./misc.nix
          ./mumble.nix
        ];
      };

    services-common =
      { username, ... }:
      {
        # Some programs need SUID wrappers, can be configured further or are
        # started in user sessions.
        # programs.mtr.enable = true;
        programs.gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };

        # https://github.com/viperML/nh
        programs.nh = {
          enable = true;
          flake = "/home/${username}/nixos";
        };
      };
  };
}
