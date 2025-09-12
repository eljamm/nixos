{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  leptonica,
  qt6,
  tesseract,
  testers,
  kdePackages,
  onnxruntime,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crow-translate";
  version = "4.0.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "crow-translate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hrxYC6zdh4aG9AkHZcnOE5jihJSo3xrq0hzBRE8NtRw=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace data/org.kde.CrowTranslate.desktop.in \
      --subst-var-by QT_BIN_DIR ${lib.getBin qt6.qttools}/bin
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kwayland
    leptonica
    tesseract
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtscxml
    qt6.qtspeech
  ]
  ++ lib.optionals finalAttrs.passthru.withPiper [
    onnxruntime
  ];

  cmakeFlags = [
    (lib.cmakeBool "ONNXRuntime_USE_STATIC" false)
    (lib.cmakeFeature "WITH_PIPER_TTS" (if finalAttrs.passthru.withPiper then "ON" else "OFF"))
  ];

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    withPiper = false;
  };

  meta = {
    description = "Simple and lightweight translator that allows to translate and speak text using Google, Yandex and Bing";
    homepage = "https://invent.kde.org/office/crow-translate";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
    mainProgram = "crow";
  };
})
