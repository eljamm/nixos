_: {
  hardware.bluetooth = {
    enable = true;
    input.General = {
      UserspaceHID = true;
    };
  };

  services.udev.extraRules = ''
    # DualShock 4 over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"

    # DualShock 4 wireless adapter over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"

    # DualShock 4 Slim over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"
  '';

  boot.kernelModules = [ "hid-playstation" ];
}
