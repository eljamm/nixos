{
  pkgs,
  ...
}:
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
    # clang # TODO: remove. big closure
    # clang-tools # TODO: remove. big closure
    cmake
    gcc
    gnumake
  ];

  gamedev = [
    # parser, linter and formatter for GDScript
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

  # TODO: big closure. should be enabled per-project
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
    (mdformat.withPlugins (
      ps: with ps; [
        mdformat-footnote
        mdformat-frontmatter
        mdformat-tables
        mdformat-toc
      ]
    ))
    # typst-lsp # FIX: broken
    # plantuml # TODO: remove. big closure
  ];

  nix = [
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
    bacon # background code check
    taplo # TOML
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
    # ++ haskell # TODO: remove (enable per-project)
    ++ luaTools
    # ++ markup # TODO: remove (already enabled system-wide)
    ++ nix
    ++ python
    # ++ rust # TODO: remove (already enabled system-wide)
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

  # NOTE: unused
  programs.helix = {
    enable = false;
    inherit extraPackages;
  };
}
