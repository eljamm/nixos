{
  lib,
  pkgs,
  pkgsUnstable,
  ...
}:
let
  packages = with pkgs; {
    tools = [
      fswatch # File watcher utility, replacing libuv.fs_event for neovim 10.0
      fzf
      git
      sqlite
      tree-sitter
    ];

    c = [
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
      # plantuml # TODO: remove. big closure
    ];

    nix = [
      deadnix
      manix
      nixd
      nixfmt-rfc-style
      nixpkgs-lint-community
      statix
    ];

    python = [
      basedpyright
      black
      isort
      ruff
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

    config = [
      yaml-language-server
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
  };
in
{
  # HACK: manix
  # https://github.com/nix-community/manix/issues/18
  manual.json.enable = true;

  # for quick development
  home.packages = with packages; rust ++ markup;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgsUnstable.neovim-unwrapped;
    plugins = with pkgs.vimPlugins; [
      neorg
      telescope-cheat-nvim
    ];
    extraPackages = lib.pipe packages [
      (lib.mapAttrsToList (name: value: value))
      lib.flatten
    ];
  };
}
