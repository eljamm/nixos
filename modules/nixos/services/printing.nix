{
  pkgs,
  ...
}:
{
  # Printer
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      canon-capt
      canon-cups-ufr2
    ];
  };

  # Scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = with pkgs; [
    hplipWithPlugin
    sane-airscan
  ];
  services.udev.packages = [ pkgs.sane-airscan ];
  users.users.kuroko.extraGroups = [
    "scanner"
    "lp"
  ];
}
