{ inputs, ... }:
{
  flake.nixosModules = {
    common-graphics =
      { pkgs, lib, ... }:
      {
        hardware.graphics = {
          enable = true;
          enable32Bit = true;
          extraPackages = with pkgs; [
            vaapiVdpau
            libvdpau-va-gl
          ];
        };
      };

    graphics-amd =
      { pkgs, lib, ... }:
      let
        # Script that offloads graphics rendering to the AMD GPU
        amd-offload = pkgs.writeShellScriptBin "amd-offload" ''
          export __EGL_VENDOR_LIBRARY_FILENAMES="${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json"
          export __GLX_VENDOR_LIBRARY_NAME="mesa"
          export VK_DRIVER_FILES="${
            lib.concatStringsSep ":" [
              "${pkgs.mesa}/share/vulkan/icd.d/radeon_icd.x86_64.json"
              "${pkgs.mesa_i686}/share/vulkan/icd.d/radeon_icd.i686.json"
            ]
          }"
          export DRI_PRIME=0
          exec "$@"
        '';
      in
      {
        environment.systemPackages = [
          amd-offload
          pkgs.lact
        ];

        boot.kernelParams = [
          "acpi_os=Linux"
          # I don't remember why I added this, but it's possibly as a fix for
          # amdgpu flip_done timed out error:
          # https://gitlab.freedesktop.org/drm/amd/-/issues/2950
          "intremap=off"
          "button.lid_init_state=open"
        ];

        systemd.packages = with pkgs; [ lact ];
        systemd.services.lactd.wantedBy = [ "multi-user.target" ];

        # Overclocking
        programs.corectrl = {
          enable = true;
          gpuOverclock.enable = true;
        };

        users.users.kuroko.extraGroups = [ "corectrl" ];
      };
  };
}
