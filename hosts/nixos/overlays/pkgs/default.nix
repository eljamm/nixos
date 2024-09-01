{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (callPackage ./zen-browser.nix { })
  ];
}
