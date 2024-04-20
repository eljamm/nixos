# include .profile if it exists
[[ -f ~/.profile ]] && . ~/.profile

bind "set completion-ignore-case on"

set show-all-if-ambiguous on
set visible-stats on
set page-completions off
set -o vi # Vim mode on

if [[ -x "$(command virtualenvwrapper.sh)" ]]; then
  source $(which virtualenvwrapper.sh)
fi

pdcompress() {
  directory="compressed"
  if [[ "$1" =~ "-d" ]]; then
    if [[ ! -d "$PWD"/"$directory" ]]; then
      mkdir "$PWD"/"$directory"
    fi
    shift
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$PWD"/"$directory"/"$1" "$1"
  else
    filename=$(echo "$1" | cut -f 1 -d '.')
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$filename"-out.pdf "$1"
  fi
}

# https://github.com/nix-community/nix-direnv/wiki/Shell-integration
nixify() {
  if [ ! -e ./.envrc ]; then
    echo "use nix" >.envrc
    direnv allow
  fi
  if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
    cat >default.nix <<'EOF'
with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    bashInteractive
  ];
}
EOF
    ${EDITOR:-vim} default.nix
  fi
}
flakify() {
  if [ ! -e flake.nix ]; then
    nix flake new -t github:nix-community/nix-direnv .
  elif [ ! -e .envrc ]; then
    echo "use flake" >.envrc
    direnv allow
  fi
  ${EDITOR:-vim} flake.nix
}
