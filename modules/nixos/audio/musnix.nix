{
  config,
  inputs,
  lib,
  ...
}:

{
  imports = [ inputs.musnix.nixosModules.musnix ];

  musnix.enable = lib.mkDefault false;

  users.users.kuroko.extraGroups = lib.mkIf config.musnix.enable [ "audio" ];
}
