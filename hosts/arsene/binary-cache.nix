{
  config,
  pkgs,
  ...
}:
{
  services.harmonia = {
    cache = {
      enable = true;
      # NOTE: generate a public/private key pair with:
      #
      # $ nix-store \
      #     --generate-binary-cache-key remotebuilder.cache \
      #     /run/credstore/harmonia.secret \
      #     /run/credstore/harmonia.pub
      signKeyPaths = [ "/run/credstore/harmonia.secret" ];
    };

    # TODO: NixOS 26.11
    #gc = {
    #  enable = true;
    #};
  };

  services.caddy = {
    enable = true;
    virtualHosts."http://remotebuilder.cache" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:5000
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [
    443
    80
  ];
}
