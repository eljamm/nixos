{
  lib,
  pkgs,
  pkgsCustom,
  ...
}:
{
  upscale-img = pkgs.writeShellApplication {
    name = "upscale-img";
    text = lib.readFile ./upscale-img;
    runtimeInputs = with pkgs; [
      jpegoptim
      optipng
      pkgsCustom.waifu2x-ncnn-vulkan
      realesrgan-ncnn-vulkan
    ];
  };
}
