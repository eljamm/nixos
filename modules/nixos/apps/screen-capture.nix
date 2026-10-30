{
  pkgs,
  ...
}:
{
  programs.obs-studio = {
    enable = true;
    # If this is non-null, the module installs the non-lazy obs-studio in the
    # system, which we don't want.
    #
    # Instead, we wrap obs ourselves, below, the same way the module does, but
    # as a lazy app.
    package = null;
    enableVirtualCamera = true;
  };

  programs.gpu-screen-recorder.enable = true;
  environment.systemPackages = with pkgs; [
    (pkgs.mkLazyApp (
      pkgs.wrapOBS.override { inherit obs-studio; } {
        plugins = with pkgs.obs-studio-plugins; [
          obs-backgroundremoval
          obs-pipewire-audio-capture
          obs-vkcapture
          wlrobs
        ];
      }
    ))

    gpu-screen-recorder-gtk
  ];
}
