{
  pkgs,
  ...
}:
{
  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # wireless support via wpa_supplicant

  # Enable networking
  networking.networkmanager.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable network proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
}
