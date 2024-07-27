{ lib, ... }:

{
  programs.bash = {
    enable = true;
    sessionVariables = {
      VIRTUALENVWRAPPER_PYTHON = "python3";
    };

    initExtra = lib.readFile ./init.sh;

    shellAliases = {
      clr = "clear && history -c";
    };
  };
}
