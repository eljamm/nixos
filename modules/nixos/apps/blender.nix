{ inputs, pkgs, ... }:
{
  nixpkgs.overlays = [ inputs.blender-bin.overlays.default ];
  environment.systemPackages = with pkgs; [ blender_4_2 ];
}
