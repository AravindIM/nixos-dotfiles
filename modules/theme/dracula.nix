{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    fira-code
  ];
  gtk = {
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode";
    };
  };
}
