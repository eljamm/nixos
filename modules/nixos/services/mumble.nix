{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.mumble ];
  services.murmur = {
    enable = true;
    openFirewall = true;
  };
}
