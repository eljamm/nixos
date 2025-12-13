{
  lib,
  fetchFromGitHub,
  yaziPlugins,
}:
yaziPlugins.mkYaziPlugin {
  pname = "nav-parent-panel";
  version = "0-unstable-2025-09-15";

  src = fetchFromGitHub {
    owner = "yaqihou";
    repo = "nav-parent-panel.yazi";
    rev = "e72b944cf58d227a80bbd816031068870b20178f";
    hash = "sha256-jKCCggyldQrdw88DaNXNuLbEq88HgoWc0oCCWTtQF2g=";
  };

  meta = {
    description = "Yazi plugin to navigate between sibling directories in the parent folder without leaving the current directory";
    homepage = "https://github.com/yaqihou/nav-parent-panel.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
