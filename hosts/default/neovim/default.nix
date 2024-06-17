{ pkgs, ... }:
with pkgs;
let

  tools = [
    fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
    fzf
    git
    sqlite
    tree-sitter
  ];

  c = [
    clang
    clang-tools
    cmake
    gcc
    gnumake
  ];

  gamedev = [
    gdtoolkit # parser, linter and formatter for Godot (GDScript)
  ];

  golang = [
    delve # debugger
    go
    gofumpt
    goimports-reviser
    golines
    gopls
    gotools
  ];

  haskell = [
    haskell-language-server
    ghc
  ];

  lua = [
    lua-language-server
    stylua
  ];

  markup = [
    codespell
    markdownlint-cli
    typst-lsp
  ];

  nix = [
    alejandra
    nil
    nixfmt-rfc-style
    nixpkgs-fmt
    statix
  ];

  python = [
    black
    isort
    python311Packages.jedi-language-server
    ruff
    ruff-lsp
  ];

  rust = [
    rustToolchain
    bacon # background code check
  ];
  rustToolchain = pkgs.fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
    "rust-analyzer"
  ];

  shell = [
    nodePackages.bash-language-server
    shellcheck
    shfmt
  ];

  web = [
    deno
    nodePackages.sql-formatter
    nodePackages.typescript-language-server
    nodejs
    prettierd # multi-language formatters
    vscode-langservers-extracted
    yarn
  ];

  extraPackages =
    tools
    ++ c
    ++ gamedev
    ++ golang
    ++ haskell
    ++ lua
    ++ markup
    ++ nix
    ++ python
    ++ rust
    ++ shell
    ++ web;
in

{
  # for quick development
  home.packages = rust;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
    plugins = with pkgs.vimPlugins; [ telescope-cheat-nvim ];
    inherit extraPackages;
  };

  programs.helix = {
    enable = true;
    inherit extraPackages;
  };
}
