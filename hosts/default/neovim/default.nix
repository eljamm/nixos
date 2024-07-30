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
    # parser, linter and formatter for GDScript
    gdtoolkit_3
    gdtoolkit_4
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

  luaTools = [
    lua-language-server
    lua51Packages.lua
    lua51Packages.luarocks-nix
    stylua
  ];

  markup = [
    cbfmt # format codeblocks
    codespell
    nodePackages.cspell
    markdownlint-cli
    # TODO: mdformat plugins don't work outside of dev shells
    (mdformat.withPlugins (ps: [
      ps.mdformat-footnote
      ps.mdformat-frontmatter
      ps.mdformat-tables
      ps.mdformat-toc
    ]))
    typst-lsp
    plantuml
  ];

  nix = [
    alejandra
    deadnix
    manix
    nil
    nixfmt-rfc-style
    nixpkgs-lint-community
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
    taplo # TOML
  ];
  rustToolchain = fenix.stable.withComponents [
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
    ++ luaTools
    ++ markup
    ++ nix
    ++ python
    ++ rust
    ++ shell
    ++ web;
in

{
  # HACK: manix
  # https://github.com/nix-community/manix/issues/18
  manual.json.enable = true;

  # for quick development
  home.packages = rust ++ markup;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = neovim-unwrapped;
    plugins = with vimPlugins; [
      neorg
      telescope-cheat-nvim
    ];
    inherit extraPackages;
  };

  programs.helix = {
    enable = true;
    inherit extraPackages;
  };
}
