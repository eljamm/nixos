{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  libunistring,
  harfbuzz,
  fontconfig,
  pkg-config,
  ncurses,
  imagemagick,
  libstartup_notification,
  libGL,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libxkbcommon,
  libXi,
  libXext,
  wayland-protocols,
  wayland,
  xxHash,
  nerdfonts,
  lcms2,
  librsync,
  openssl,
  installShellFiles,
  dbus,
  sudo,
  libcanberra,
  wayland-scanner,
  simde,
  bashInteractive,
  zsh,
  fish,
  nixosTests,
  go,
  buildGoModule,
  nix-update-script,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "kitty";
  version = "0.34.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "kovidgoyal";
    repo = "kitty";
    rev = "refs/tags/v${version}";
    hash = "sha256-r7KZcSqREILMp0F9ajeHS5sglq/o88h2t+4BgbABjOY=";
  };

  inherit
    (
      (buildGoModule {
        pname = "kitty-go-modules";
        inherit src version;
        vendorHash = "sha256-HNE0MWjL0PH20Glzb0GV6+lQu/Lslx8k/+YvlLHbHww=";
      })
    )
    goModules
    ;

  buildInputs =
    [
      harfbuzz
      ncurses
      simde
      lcms2
      librsync
      openssl.dev
      xxHash
    ]
    ++ lib.optionals stdenv.isLinux [
      fontconfig
      libunistring
      libcanberra
      libX11
      libXrandr
      libXinerama
      libXcursor
      libxkbcommon
      libXi
      libXext
      wayland-protocols
      wayland
      dbus
      libGL
    ];

  nativeBuildInputs =
    (with python3.pkgs; [
      sphinx
      furo
      sphinx-copybutton
      sphinxext-opengraph
      sphinx-inline-tabs
    ])
    ++ [
      installShellFiles
      ncurses
      pkg-config
      go
      fontconfig
      wayland-scanner
    ];

  depsBuildBuild = [ pkg-config ];

  outputs = [
    "out"
    "terminfo"
    "shell_integration"
    "kitten"
  ];

  patches = [
    # Gets `test_ssh_env_vars` to pass when `bzip2` is in the output of `env`.
    ./fix-test_ssh_env_vars.patch
  ];

  hardeningDisable = [
    # causes redefinition of _FORTIFY_SOURCE
    "fortify3"
  ];

  CGO_ENABLED = 0;
  GOFLAGS = "-trimpath";

  configurePhase = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    export GOPROXY=off
    cp -r --reflink=auto $goModules vendor
  '';

  buildPhase =
    let
      commonOptions = ''
        --update-check-interval=0 \
        --shell-integration=enabled\ no-rc
      '';
    in
    ''
      runHook preBuild

      # Add the font by hand because fontconfig does not finds it in darwin
      mkdir ./fonts/
      cp "${
        (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      }/share/fonts/truetype/NerdFonts/SymbolsNerdFontMono-Regular.ttf" ./fonts/

      ${python3.pythonOnBuildForHost.interpreter} setup.py linux-package \
      --egl-library='${lib.getLib libGL}/lib/libEGL.so.1' \
      --startup-notification-library='${libstartup_notification}/lib/libstartup-notification-1.so' \
      --canberra-library='${libcanberra}/lib/libcanberra.so' \
      --fontconfig-library='${fontconfig.lib}/lib/libfontconfig.so' \
      ${commonOptions}
      ${python3.pythonOnBuildForHost.interpreter} setup.py build-launcher

      runHook postBuild
    '';

  nativeCheckInputs = [
    python3.pkgs.pillow

    # Shells needed for shell integration tests
    bashInteractive
    zsh
    fish

    # integration tests need sudo
    sudo
  ];

  checkPhase = ''
    runHook preCheck

    # Fontconfig error: Cannot load default config file: No such file: (null)
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf

    # Required for `test_ssh_shell_integration` to pass.
    export TERM=kitty

    make test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out"
    mkdir -p "$kitten/bin"

    cp -r linux-package/{bin,share,lib} "$out"
    cp linux-package/bin/kitten "$kitten/bin/kitten"

    # dereference the `kitty` symlink to make sure the actual executable
    # is wrapped on macOS as well (and not just the symlink)
    wrapProgram $(realpath "$out/bin/kitty") --prefix PATH : "$out/bin:${
      lib.makeBinPath [
        imagemagick
        ncurses.dev
      ]
    }"

    installShellCompletion --cmd kitty \
      --bash <("$out/bin/kitty" +complete setup bash) \
      --fish <("$out/bin/kitty" +complete setup fish2) \
      --zsh  <("$out/bin/kitty" +complete setup zsh)

    terminfo_src="$out/share/terminfo"

    mkdir -p $terminfo/share
    mv "$terminfo_src" $terminfo/share/terminfo

    mkdir -p "$out/nix-support"
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages

    cp -r 'shell-integration' "$shell_integration"

    runHook postInstall
  '';

  passthru = {
    tests = lib.optionalAttrs stdenv.isLinux {
      default = nixosTests.terminal-emulators.kitty;
    };
    updateScript = nix-update-script { };
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/kovidgoyal/kitty";
    description = "Modern, hackable, featureful, OpenGL based terminal emulator";
    license = lib.licenses.gpl3Only;
    changelog = [
      "https://sw.kovidgoyal.net/kitty/changelog/"
      "https://github.com/kovidgoyal/kitty/blob/v${version}/docs/changelog.rst"
    ];
    platforms = lib.platforms.linux;
    mainProgram = "kitty";
    maintainers = with lib.maintainers; [
      tex
      rvolosatovs
      Luflosi
      kashw2
    ];
  };
}
