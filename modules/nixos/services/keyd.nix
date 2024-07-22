_: {
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          # NOTE: valid key names: `keyd list-keys`
          main = {
            # Remap caps to `escape`
            capslock = "esc";

            # Newline on enter
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
          };
        };
      };
    };
  };
}
