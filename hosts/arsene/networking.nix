{
  username,
  ...
}:
{
  networking.hostName = "arsene";

  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;  # wireless support via wpa_supplicant

  # TODO:
  #networking.interfaces.enp2s0.wakeOnLan.enable = true;

  users.users.${username}.extraGroups = [ "networkmanager" ];

  # Enable SSH
  services.openssh = {
    enable = true;
    # settings.PasswordAuthentication = false;
    settings.PasswordAuthentication = true;
    settings.KbdInteractiveAuthentication = false;
    settings.PermitRootLogin = "yes";
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "AAAAC3NzaC1lZDI1NTE5AAAAICZvS8+rmp2JQ2tgoFrXncNuydujpqkLpqlVjf+ufFpT"
  ];

  # Handle remote connection from all terminal emulators
  # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/config/terminfo.nix#L39
  environment.enableAllTerminfo = true;
}
