{ pkgs, ... }:

{
  config = {
    environment.systemPackages = with pkgs; [
      zathura
      qownnotes
    ];
  };
}
