{
  lib,
  inputs,
  ...
}:
{
  flake.nixosModules = {
    audio =
      { config, lib, ... }:
      {
        # Enable sound with pipewire.
        services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;

          # use the example session manager (no others are packaged yet so this is enabled by default,
          # no need to redefine it in your config for now)
          #media-session.enable = true;
        };

        # Music plugin paths
        environment.variables =
          let
            makePluginPath =
              format:
              (lib.makeSearchPath format [
                "$HOME/.nix-profile/lib"
                "/run/current-system/sw/lib"
                "/etc/profiles/per-user/$USER/lib"
              ])
              + ":$HOME/.${format}";
          in
          {
            DSSI_PATH = lib.mkDefault (makePluginPath "dssi");
            LADSPA_PATH = lib.mkDefault (makePluginPath "ladspa");
            LV2_PATH = lib.mkDefault (makePluginPath "lv2");
            LXVST_PATH = lib.mkDefault (makePluginPath "lxvst");
            VST_PATH = lib.mkDefault (makePluginPath "vst");
            VST3_PATH = lib.mkDefault (makePluginPath "vst3");
          };
      };

    spec-musnix =
      {
        lib,
        username,
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
      };
  };
}
