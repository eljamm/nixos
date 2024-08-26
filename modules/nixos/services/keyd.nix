{ lib, ... }:
let
  # NOTE: valid key names: `keyd list-keys`
  commonSettings = {
    main = {
      capslock = "esc";
      insert = "S-insert";
    };
    altgr = {
      capslock = "backspace";

      # Vim
      k = "up";
      l = "right";
      j = "down";
      h = "left";
      x = "C-w"; # close

      # Screenshot
      i = "sysrq";

      g = "home";
    };
    "altgr+shift" = {
      j = "pagedown";
      k = "pageup";

      # Media keys
      a = "previoussong";
      d = "nextsong";

      e = "volumeup";
      q = "volumedown";

      m = "mute";
      s = "playpause";

      f = "rfkill";

      g = "end";
    };
    "control+shift" = {
      # Next/Previous Tabs
      j = "C-S-tab";
      k = "C-tab";
    };
  };
in
{
  services.keyd = {
    enable = true;
    keyboards = {
      dierya = {
        ids = [ "1a2c:95f6" ];
        settings = lib.recursiveUpdate commonSettings {
          main = {
            esc = "^";
            y = "z";
            z = "y";
          };
          altgr = {
            r = "macro(leftalt+home)";
          };
          shift = {
            esc = "`";
          };
          "alt" = {
            esc = "~";
          };
        };
      };
      default = {
        ids = [ "*" ];
        settings = commonSettings;
      };
    };
  };
}
