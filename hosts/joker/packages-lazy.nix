{
  pkgs,
  pkgsUnstable,
  ...
}:
{
  custom.systemPackages = with pkgs; {
    gaming = {
      launchers = [
        (pkgs.mkLazyApp prismlauncher)
      ];
      games = [
        (pkgs.mkLazyApp pkgsUnstable.unciv)
      ];
    };
    tools = {
      drawing = [
        (pkgs.mkLazyApp blender)
        (pkgs.mkLazyApp krita)
      ];
    };

    development = {
      audio = {
        trackers = [
          (pkgs.mkLazyApp tuxguitar)
        ];
      };
    };
  };
}
