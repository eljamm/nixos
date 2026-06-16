{
  lib,
  pkgs,
  pkgsUnstable,
  pkgsCustom,
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

    luaTools = [
      lua-language-server
      lua51Packages.lua
      lua51Packages.luarocks-nix
      stylua
    ];

    markup = [
      cbfmt # format codeblocks
      codespell
      cspell
      markdownlint-cli
    ];

    nix = [
      deadnix
      manix
      pkgsUnstable.nixd
      nixfmt
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
      # pkgsCustom.rustowl # visualize lifetimes
    ];

    shell = [
      bash-language-server
      shellcheck
      shfmt
    ];

    config = [
      yaml-language-server
    ];

    web = [
      deno
      nodejs
      prettierd # multi-language formatters
      sql-formatter
      typescript-language-server
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
    # Disable Python and Ruby providers. See:
    # https://github.com/nix-community/home-manager/pull/9055
    withPython3 = false;
    withRuby = false;
    # Load `init.lua` through neovim wrapper instead of writing to
    # `$XDG_CONFIG_HOME/nvim/init.lua`
    sideloadInitLua = true;
    package = pkgsUnstable.neovim-unwrapped;
    plugins = with pkgsUnstable.vimPlugins; [
      neorg
      telescope-cheat-nvim
    ];
    extraPackages = lib.pipe packages [
      lib.attrValues
      lib.flatten
    ];
  };

  programs.neovide = {
    enable = true;
    package = pkgsUnstable.neovide;
  };
}
