{ pkgs, lib, ... }:
let
  rustToolchain = pkgs.fenix.stable.withComponents [
    "cargo"
    "clippy"
    "rust-src"
    "rustc"
    "rustfmt"
    "rust-analyzer"
  ];
in

{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-nightly;
    extraPackages = with pkgs; [
      ## Formatters/linters ##
      codespell
      markdownlint-cli
      # go
      gofumpt
      goimports-reviser
      golines
      # lua
      stylua
      # multi-language
      prettierd
      shfmt
      # nix
      alejandra
      nixpkgs-fmt
      # python
      black
      isort
      ruff

      ## LSPs ##
      gopls
      lua-language-server
      nil # nix
      typst-lsp
      # web
      deno
      vscode-langservers-extracted
      nodePackages.typescript-language-server
      # python
      python311Packages.jedi-language-server
      ruff-lsp

      ## Debuggers ##
      delve # Go

      ## Toolchains ##
      rustToolchain
      gdtoolkit # parser, linter and formatter for Godot (GDScript)

      ## Tools ##
      fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
      fzf
      git
      sqlite
      tree-sitter
      # c/c++
      clang
      cmake
      gcc
      gnumake
      # go
      go
      gotools
      # web
      nodejs
    ];
  };
}
