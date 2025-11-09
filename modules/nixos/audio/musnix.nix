{
  lib,
  username,
  inputs,
  ...
}:
{
  specialisation.music-production.configuration = {
    system.nixos.tags = [ "music-production" ];
    environment.etc."specialisation".text = "music-production"; # hint for nh

    imports = [
      inputs.musnix.nixosModules.musnix
    ];

    musnix.enable = lib.mkDefault true;
    musnix.rtcqs.enable = true;
    musnix.soundcardPciId = "34:00.6";

    services.scx.scheduler = "scx_flash";

    # musnix.kernel.realtime = true;
    # musnix.das_watchdog.enable = true;
    # boot.kernelPackages = lib.mkForce pkgs.linuxPackages-rt_latest;

    users.users.${username}.extraGroups = [ "audio" ];
  };
}
