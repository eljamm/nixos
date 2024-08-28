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

      g = "home";

      # Vim
      k = "up";
      l = "right";
      j = "down";
      h = "left";
      x = "C-w"; # close

      # Screenshot
      i = "sysrq";

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
    counter :: (int -> int) -> [string]

    ```
    counter 1 5
    => [ "1" "2" "3" "4" "5" ]
    ```
  */
  counter = i: l: if i < l then [ (toString i) ] ++ counter (i + 1) l else [ (toString i) ];

  /**
    mkFuncKeys :: [string] -> AttrSet

    ```
    mkFuncKeys [ "1" "2" ]
    => { "1" = "f1"; "2" = "f2"; }
    ```
  */
  mkFuncKeys =
    keys:
    lib.pipe keys [
      (map (i: {
        name = "${i}";
        value = "f${i}";
      }))
      lib.listToAttrs
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
          altgr = (mkFuncKeys (counter 1 9)) // {
            "0" = "f10";
            "-" = "f11";
            "=" = "f12";
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
