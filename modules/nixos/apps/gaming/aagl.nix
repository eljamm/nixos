{ inputs, ... }:

{
  imports = [ inputs.aagl.nixosModules.default ];

  programs.honkers-railway-launcher.enable = true;
}
