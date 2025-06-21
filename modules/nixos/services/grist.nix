{
  config,
  username,
  ...
}:
{
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

  systemd.tmpfiles.settings = {
    "10-grist" = {
      "/home/${username}/grist"."d" = {
        user = username;
        group = "users";
        mode = "0740";
      };
    };
  };
}
