{ config, lib, ... }:

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
  imports = [ ./musnix.nix ];

  # Music plugin paths
  # NOTE: musnix already enables these, so we don't set them if it's enabled
  environment.variables = lib.mkIf (!config.musnix.enable) {
    DSSI_PATH = makePluginPath "dssi";
    LADSPA_PATH = makePluginPath "ladspa";
    LV2_PATH = makePluginPath "lv2";
    LXVST_PATH = makePluginPath "lxvst";
    VST_PATH = makePluginPath "vst";
    VST3_PATH = makePluginPath "vst3";
  };
}
