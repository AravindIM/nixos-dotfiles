{ config, lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    history = {
      extended = true;
      size = 1000;
      save = 1000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    shellAliases = {
      ls = "lsd";
      grep = "grep --color=auto";
      vim = "nvim";
      vi = "nvim";
    };

    initExtra = ''
      # Don't slow the zsh if not interactively run
      [[ $- != *i* ]] && return

      # Settings
      setopt autocd beep extendedglob nomatch notify
      bindkey -e

      # Completion setup
      autoload -Uz compinit
      compinit
      autoload -Uz bashcompinit
      bashcompinit

      # Environment variables
      export EDITOR="vim"
      export VISUAL="$EDITOR"
      export PATH="$PATH:$HOME/.local/bin"
      export PATH="$PATH:$HOME/go/bin"
      export PATH="$PATH:$HOME/.local/share/flutter/bin"
      export PATH="$PATH:$HOME/.local/share/istio/bin"
      export XDG_SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"

      export GPG_TTY=$(tty)
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DBUS_REMOTE=1

      # Node Version Manager
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

      # Load .envrc if exists
      [ -s "$HOME/.envrc" ] && . "$HOME/.envrc"
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  # Optional: include zsh plugins from nixpkgs if you want explicit sources
  home.packages = with pkgs; [
    lsd
    zsh-autosuggestions
    zsh-syntax-highlighting
  ];
}
