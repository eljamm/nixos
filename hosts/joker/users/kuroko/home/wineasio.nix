# https://github.com/wineasio/wineasio/issues/70#issuecomment-1793514875
{
  pkgs,
  ...
}:
let
  winePkg = pkgs.wineWow64Packages.staging;
  wine = "${winePkg}/bin/wine";
  so = "${pkgs.wineasio}/lib/wine/x86_64-unix/wineasio64.dll.so";
  dest = "$WINEPREFIX/drive_c/windows/system32/wineasio64.dll";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "register-wineasio" ''
      cp -v ${so} ${dest}
      chmod +w ${dest}
      ${wine} regsvr32 ${so}
    '')
  ];
}
