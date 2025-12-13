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

  scripts.sorterelli = pkgs.writers.writePython3Bin "sorterelli" {
    libraries = with pkgs.python3Packages; [
      python-magic
      tqdm
    ];
    doCheck = false;
  } (lib.readFile ./sorterelli.py);

  scripts.chaptocue = pkgs.writers.writePython3Bin "chaptocue" {
    libraries = with pkgs.python3Packages; [ yt-dlp ];
    doCheck = false;
  } (lib.readFile ./chaptocue.py);

  # expose scripts for debugging
  config.debug.scripts = scripts;

  # install scripts in system
  config.environment.systemPackages = lib.attrValues scripts;
in
config
