{
  lib,
  stdenv,
  darwin,
  fetchFromGitHub,
  rust,
  rustPlatform,
  cargo-tauri,
  cinny,
  copyDesktopItems,
  wrapGAppsHook3,
  pkg-config,
  openssl,
  dbus,
  glib,
  glib-networking,
  libayatana-appindicator,
  webkitgtk,
  makeDesktopItem,
}:

rustPlatform.buildRustPackage rec {
  pname = "cinny-desktop";
  # We have to be using the same version as cinny-web or this isn't going to work.
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "cinnyapp";
    repo = "cinny-desktop";
    rev = "v${version}";
    hash = "sha256-3HwKDD0O1Yx2OIjyO5FhV4d1INAIFXMO7FjSL7cOVmI=";
  };

  sourceRoot = "${src.name}/src-tauri";

  cargoHash = "sha256-CwB4S/5UuDH1LlJ4CY77XUCriplT3ZFfdg1j41AUoTI=";

  postPatch =
    let
      cinny' =
        assert lib.assertMsg (
          cinny.version == version
        ) "cinny.version (${cinny.version}) != cinny-desktop.version (${version})";
        cinny.override {
          conf = {
            hashRouter.enable = true;
          };
        };
    in
    ''
      substituteInPlace tauri.conf.json \
        --replace '"distDir": "../cinny/dist",' '"distDir": "${cinny'}",'
      substituteInPlace tauri.conf.json \
        --replace '"cd cinny && npm run build"' '""'
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
        --replace "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    '';

  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cargo tauri build --bundles app --target "${rust.envVars.rustHostPlatform}"
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -DT icons/128x128@2x.png $out/share/icons/hicolor/256x256@2/apps/cinny.png
      install -DT icons/128x128.png $out/share/icons/hicolor/128x128/apps/cinny.png
      install -DT icons/32x32.png $out/share/icons/hicolor/32x32/apps/cinny.png
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p "$out/Applications/"
      cp -r "target/${rust.envVars.rustHostPlatform}/release/bundle/macos/Cinny.app" "$out/Applications/"
      ln -sf "$out/Applications/Cinny.app/Contents/MacOS/Cinny" "$out/bin/cinny"
    '';

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
    pkg-config
    cargo-tauri
  ];

  buildInputs =
    [
      openssl
      dbus
      glib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      libayatana-appindicator
      webkitgtk
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.DarwinTools
      darwin.apple_sdk.frameworks.WebKit
    ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "cinny";
      exec = "cinny";
      icon = "cinny";
      desktopName = "Cinny";
      comment = meta.description;
      categories = [
        "Network"
        "InstantMessaging"
      ];
    })
  ];

  meta = {
    description = "Yet another matrix client for desktop";
    homepage = "https://github.com/cinnyapp/cinny-desktop";
    maintainers = with lib.maintainers; [
      qyriad
      ryand56
    ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "cinny";
  };
}
