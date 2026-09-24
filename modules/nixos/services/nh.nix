{
  username,
  ...
}:
{
  # https://github.com/viperML/nh
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nixos";
  };
}
