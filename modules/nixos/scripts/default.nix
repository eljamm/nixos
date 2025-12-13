{
  lib,
  pkgs,
  pkgsCustom,
  ...
}:
let
  scripts.upscale-img = pkgs.writeShellApplication {
    name = "upscale-img";
    text = lib.readFile ./upscale-img;
    runtimeInputs = with pkgs; [
      jpegoptim
      optipng
      pkgsCustom.waifu2x-ncnn-vulkan
      realesrgan-ncnn-vulkan
    ];
  };

  # expose scripts for debugging
  config.debug.scripts = scripts;

  # install scripts in system
  config.environment.systemPackages = lib.attrValues scripts;
in
config
