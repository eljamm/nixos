{ ... }:
{
  imports = [
    ./kitty
    ./wezterm
  ];

  programs.foot = {
    enable = true;
  };
}
