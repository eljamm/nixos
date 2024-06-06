# Empty greeter
set fish_greeting

# Make prompt path to the following format:
# ~/a/b/hello/world
function fish_title
    echo (fish_prompt_pwd_dir_length=1 fish_prompt_pwd_full_dirs=2 prompt_pwd): $argv;
end

# Enable vim-style keybinds
fish_vi_key_bindings

# Make <c-f> work for vi-mode
bind -M insert \cf forward-char
