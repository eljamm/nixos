{
  pkgs,
  ...
}:
{
  networking.hostName = "nixos";
  # networking.wireless.enable = true;  # wireless support via wpa_supplicant

  # Enable network proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  programs.wireshark.enable = true;

  environment.systemPackages = with pkgs; [ wireshark ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
