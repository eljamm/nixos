{
  lib,
  fetchFromGitHub,
  python3Packages,
  wrapQtAppsHook,
  gst_all_1,
  qtbase,
  qtmultimedia,
}:
python3Packages.buildPythonApplication rec {
  pname = "vocabsieve";
  version = "0.12.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "FreeLanguageTools";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-d0WVgBuKVTZyUvvSWD4ku6zSK6pWzQRl91M8nEdFbA4=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  buildInputs = [
    qtbase
    qtmultimedia
  ];

  build-system = with python3Packages; [ setuptools ];

  propagatedBuildInputs = with python3Packages; [
    bidict
    ebooklib
    flask
    flask-sqlalchemy
    gevent
    lxml
    markdown
    markdownify
    mobi
    packaging
    pymorphy3
    pymorphy3-dicts-ru
    pymorphy3-dicts-uk
    pynput
    pyqt5_with_qtmultimedia
    pyqtdarktheme
    pyqtgraph
    pystardict
    pysubs2
    python-lzo
    readmdict
    requests
    sentence-splitter
    simplemma
    slpp
  ];

  meta = {
    description = "Simple sentence mining tool for language learning";
    homepage = "https://github.com/FreeLanguageTools/vocabsieve";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
