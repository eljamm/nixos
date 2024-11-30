{ username, ... }:
{
  networking.hostName = "navi";

  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  networking.interfaces.enp2s0.wakeOnLan.enable = true;

  users.users.${username}.extraGroups = [ "networkmanager" ];

  # Enable SSH
  services.openssh = {
    enable = true;
    # settings.PasswordAuthentication = false;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  # Handle remote connection from all terminal emulators
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/terminfo.nix#L39
  environment.enableAllTerminfo = true;
}
