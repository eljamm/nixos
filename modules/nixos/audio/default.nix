{
  inputs,
  lib,
  username,
  ...
}:
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
        environment.variables = {
          DSSI_PATH = lib.mkDefault (makePluginPath "dssi");
          LADSPA_PATH = lib.mkDefault (makePluginPath "ladspa");
          LV2_PATH = lib.mkDefault (makePluginPath "lv2");
          LXVST_PATH = lib.mkDefault (makePluginPath "lxvst");
          VST_PATH = lib.mkDefault (makePluginPath "vst");
          VST3_PATH = lib.mkDefault (makePluginPath "vst3");
        };
      };

    audio-musnix =
      { config, lib, ... }:
      {
        imports = [ inputs.musnix.nixosModules.musnix ];

        musnix.enable = lib.mkDefault true;

        users.users.${username}.extraGroups = lib.mkIf config.musnix.enable [ "audio" ];
      };
  };
}
