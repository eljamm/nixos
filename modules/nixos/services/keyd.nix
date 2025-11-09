{
  lib,
  ...
}:
let
  # NOTE: valid key names: `keyd list-keys`
  commonSettings = {
    main = {
      capslock = "esc";
      insert = "S-insert";
    };
    altgr = {
      capslock = "backspace";

      g = "home";

      # Vim
      k = "up";
      l = "right";
      j = "down";
      h = "left";
      x = "C-w"; # close

      # Screenshot
      i = "sysrq";

      m = "micmute";

      # go home in pcmanfm-qt
      r = "macro(leftalt+home)";
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
    # "control+shift" = {
    #   # Next/Previous Tabs
    #   j = "C-S-tab";
    #   k = "C-tab";
    # };
  };

  /**
    mkDefaultFuncKeys :: (int -> int) -> AttrSet

    ```
    mkDefaultFuncKeys 1 2
    => { "1" = "f1"; "2" = "f2"; }
    ```
  */
  mkDefaultFuncKeys =
    i: j:
    with lib;
    pipe (range i j) [
      (map toString)
      (map (i: {
        "${i}" = "f${i}";
      }))
      mergeAttrsList
    ];
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
          altgr = (mkDefaultFuncKeys 1 9) // {
            "0" = "f10";
            "-" = "f11";
            "=" = "f12";

            "d" = "delete";
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
