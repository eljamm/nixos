{
  config,
  pkgsUnstable,
  username,
  ...
}:
{
  programs.firejail.enable = true;

  programs.adb.enable = true;

  # https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;

  # https://github.com/mic92/envfs
  services.envfs.enable = true;

  # Reddit
  services.redlib.enable = true;
  services.redlib.package = pkgsUnstable.redlib;

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      grist = {
        image = "gristlabs/grist";
        volumes = [
          "/home/${username}/grist:/persist"
        ];
        ports = [ "8484:8484" ];
        environment = {
          GRIST_SESSION_SECRET = config.age.secrets.grist_session.path;
          GRIST_DEFAULT_EMAIL = config.age.secrets.grist_email.path;
        };
      };
    };
  };

}
