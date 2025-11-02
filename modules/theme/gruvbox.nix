{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.departure-mono
  ];
  gtk = {
    enable = true;
    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-dark-gtk;
    };
    iconTheme = {
      name = "Gruvbox Plus Dark";
      package = pkgs.gruvbox-plus-icons;
    };
    font = {
      name = "Departure Mono NerdFont";
    };
  };
}
