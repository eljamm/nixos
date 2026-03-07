{
  pkgs,
  ...
}:
{
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vkcapture
      wlrobs
    ];
  };

  programs.gpu-screen-recorder.enable = true;
  environment.systemPackages = with pkgs; [
    gpu-screen-recorder-gtk
  ];
}
