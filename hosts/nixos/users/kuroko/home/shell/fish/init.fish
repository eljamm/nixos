# Empty greeter
set fish_greeting

# Make prompt path to the following format:
# ~/a/b/hello/world
function fish_title
    echo (fish_prompt_pwd_dir_length=1 fish_prompt_pwd_full_dirs=2 prompt_pwd): $argv;
end

# Enable vim-style keybinds
fish_vi_key_bindings

# Custom keybinds
bind -M insert \cf forward-char
bind \cf forward-char

bind -M insert \ef forward-word
bind \ef forward-word

bind -M insert \eb backward-word
bind \eb backward-word

# TODO: remove when `starship.enableInteractive` is merged in home-manager
# Starship integration with fish (necessary for async prompt)
starship init fish | source

# https://github.com/MercuryTechnologies/nix-your-shell
if command -q nix-your-shell
  nix-your-shell fish | source
end
