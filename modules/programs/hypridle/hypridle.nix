{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hypridle
  ];
  xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf;
}

