{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Common tools for Neovim plugins and LSPs
    extraPackages = with pkgs; [
      git
      ripgrep
      fd
      tree-sitter
      lua-language-server
      clang
      python3
      nodejs
      unzip
      wget
      curl
    ];
  };

  # Deploy your Lua config
  home.file.".config/nvim/init.lua".source = ./init.lua;
}
