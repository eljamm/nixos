{ pkgs, lib, ... }:
with builtins;
let
  initFile = readFile (./init.sh);
in

{

  programs.bash = {
    enable = true;
    sessionVariables = {
      VIRTUALENVWRAPPER_PYTHON = "python3";
    };

    initExtra = initFile;
  };

}
