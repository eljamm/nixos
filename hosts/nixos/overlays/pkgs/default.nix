{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (callPackage ./aseprite { })
  ];
}
