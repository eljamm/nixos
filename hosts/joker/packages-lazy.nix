{
  lazy-app,
  pkgs,
  ...
}:
{
  custom.systemPackages = {
    tools = {
      drawing = [
        (lazy-app.override {
          pkg = pkgs.blender;
          desktopItem = pkgs.runCommand "blender-desktop" { } ''
            install \
              -D ${pkgs.blender}/share/applications/blender.desktop \
              -t $out/share/applications
          '';
        })
      ];
    };
  };
}
